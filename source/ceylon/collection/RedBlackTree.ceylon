Boolean isRed<Key,Item>(Node<Key,Item>? node)
        given Key satisfies Comparable<Key> {
    if (exists node) {
        return node.red;
    }
    else {
        return false;
    }
}

class Node<Key,Item>(key, item) 
        given Key satisfies Comparable<Key> {
    
    shared variable Key key;
    shared variable Item item;
    shared variable Node<Key,Item>? left=null;
    shared variable Node<Key,Item>? right=null;
    shared variable Node<Key,Item>? parent=null;
    shared variable Boolean red=true;
    
    shared Boolean onLeft {
        if (exists parentLeft=parent?.left) {
            return this==parentLeft;
        }
        else {
            return false;
        }
    }
    
    shared Boolean onRight {
        if (exists parentRight=parent?.right) {
            return this==parentRight;
        }
        else {
            return false;
        }
    }
    
    shared Node<Key,Item>? grandparent => parent?.parent;
    
    shared Node<Key,Item>? sibling {
        if (exists p=parent) { 
            if (onLeft) {
                return p.right;
            }
            else if (onRight){
                return p.left;
            }
            else {
                assert (false);
            }
        }
        else {
            // Root node has no sibling
            return null;
        }
    }
    
    shared Node<Key,Item>? uncle => parent?.sibling;
    
    shared actual String string {
        value stringBuilder = StringBuilder();
        stringBuilder.append("(");
        if (exists l=left) {
            stringBuilder.append(l.string).append(", ");
        }
        stringBuilder.append(red then "[R]" else "[B]")
                .append(key.string)
                .append("->")
                .append(item?.string else "<null>");
        if (exists r=right) {
            stringBuilder.append(", ").append(r.string);
        }
        stringBuilder.append(")");
        return stringBuilder.string;
    }
}

shared class RBTree<Key,Item>() 
        given Key satisfies Comparable<Key> {
    
    variable Node<Key,Item>? root=null;

    shared actual String string {
        if (exists r=root) {
            return "{ " + r.string + " }";
        }
        else {
            return "{}";
        }
    }
    
    function lookup(Key key) {
        variable value node = root;
        while (exists n=node) {
            switch (key<=>n.key) 
            case (equal) {
                return n;
            } 
            case (smaller) {
                node = n.left;
            }
            case (larger) {
                node = n.right;
            }
        }
        return node;
    }
    
    shared Item? get(Key key) => lookup(key)?.item;
    
    void replaceNode(Node<Key,Item> old, Node<Key,Item>? node) {
        if (exists parent=old.parent) {
            if (old.onLeft) {
                parent.left = node;
            }
            else if (old.onRight) {
                parent.right = node;
            }
            else {
                assert (false);
            }
        }
        else {
            root = node;
        }
        if (exists node) {
            node.parent = old.parent;
        }
    }
    
    void rotateLeft(Node<Key,Item> node) {
        assert (exists right = node.right);
        replaceNode(node, right);
        node.right = right.left;
        if (exists rl=right.left) {
            rl.parent = node;
        }
        right.left = node;
        node.parent = right;
    }

    void rotateRight(Node<Key,Item> node) {
        assert (exists left = node.left);
        replaceNode(node, left);
        node.left = left.right;
        if (exists lr = left.right) {
            lr.parent = node;
        }
        left.right = node;
        node.parent = left;
    }
    
    shared void put(Key key, Item item) {
        value newNode = Node(key, item);
        if (exists root=this.root) {
            variable Node<Key,Item> node = root;
            while (true) {
                switch (key<=>node.key)
                case (larger) {
                    if (exists nr=node.right) {
                        node = nr;
                    }
                    else {
                        node.right = newNode;
                        break;
                    }
                }
                case (smaller) {
                    if (exists nl = node.left) {
                        node = nl;
                    }
                    else {
                        node.left = newNode;
                        break;
                    }
                }
                case (equal) {
                    node.item = item;
                    return;
                }
            }
            newNode.parent = node;
        }
        else {
            root = newNode;
        }
        recolorAfterInsert(newNode);
        //verifyProperties();
    }
    
    void recolorAfterInsert(Node<Key,Item> newNode) {
        if (exists parent = newNode.parent) {
            if (isRed(parent)) {
                if (exists uncle=newNode.uncle, isRed(uncle)) {
                    // a red uncle! color parent+uncle
                    // black, and grandparent red, then
                    // go up the tree making adjustments
                    // to accommodate this
                    parent.red = false;
                    uncle.red = false;
                    assert (exists grandparent=newNode.grandparent);
                    grandparent.red = true;
                    recolorAfterInsert(grandparent);
                }
                else {
                    //first rotation
                    Node<Key,Item> adjustedNode;
                    if (newNode.onRight && parent.onLeft) {
                        rotateLeft(parent);
                        assert (exists nl=newNode.left);
                        adjustedNode=nl;
                    } 
                    else if (newNode.onLeft && parent.onRight) {
                        rotateRight(parent);
                        assert (exists nr=newNode.right);
                        adjustedNode=nr;
                    }
                    else {
                        adjustedNode=newNode;
                    }
                    //second rotation
                    assert (exists adjustedParent=adjustedNode.parent);
                    adjustedParent.red = false;
                    assert (exists grandparent=adjustedNode.grandparent);
                    grandparent.red = true;
                    if (adjustedNode.onLeft && adjustedParent.onLeft) {
                        rotateRight(grandparent);
                    }
                    else if (adjustedNode.onRight && adjustedParent.onRight) {
                        rotateLeft(grandparent);
                    }
                    else {
                        assert (false);
                    }
                }
            }
            //else if the parent is black we are good
        }
        else {
            //root node is always black
            newNode.red = false;
        }
    }
    
    Node<Key,Item> rightmostChild(Node<Key,Item> node) {
        variable value rightmost = node;
        while (exists right = rightmost.right) {
            rightmost = right;
        }
        return rightmost;
    }
    
    shared void remove(Key key) {
        if (exists result = lookup(key)) {
            Node<Key,Item> node;
            if (exists left=result.left, 
                exists right=result.right) {
                // Copy key/value from predecessor and then delete it instead
                node = rightmostChild(left);
                result.key = node.key;
                result.item = node.item;
            }
            else {
                node = result;
            }
            
            Node<Key,Item>? child;
            if (exists left = node.left) {
                assert (!node.right exists);
                child = left;
            }
            else if (exists right = node.right) {
                assert (!node.left exists);
                child = right;
            }
            else {
                child = null;
            }
            if (!isRed(node)) {
                node.red = isRed(child);
                recolorAfterDeletion(node);
            }
            replaceNode(node, child);
        }
        //verifyProperties();
    }
    
    void recolorAfterDeletion(Node<Key,Item> node) {
        if (exists parent=node.parent) {
            if (exists sibling=node.sibling,
                isRed(sibling)) {
                parent.red = true;
                sibling.red = false;
                if (parent.onLeft) {
                    rotateLeft(parent);
                }
                else /*if (parent.onRight)*/ {
                    rotateRight(parent);
                }
                //else {
                //    assert (false);
                //}
            }
            if (exists sibling=node.sibling,
                !isRed(sibling) &&
                !isRed(sibling.left) &&
                !isRed(sibling.right)) {
                sibling.red = true;
                if (isRed(parent)) {
                    parent.red = false;
                }
                else {
                    recolorAfterDeletion(parent);
                }
            }
            else {
                if (exists sibling=node.sibling,
                    exists siblingLeft=sibling.left,
                    node.onLeft &&
                    !isRed(sibling) &&
                    isRed(siblingLeft) &&
                    !isRed(sibling.right)) {
                    sibling.red = true;
                    siblingLeft.red = false;
                    rotateRight(sibling);
                }
                else if (exists sibling=node.sibling,
                    exists siblingRight=sibling.right,
                    node.onRight &&
                    !isRed(sibling) &&
                    isRed(siblingRight) &&
                    !isRed(sibling.left)) {
                    sibling.red = true;
                    siblingRight.red = false;
                    rotateLeft(sibling);
                }
                if (exists sibling=node.sibling) {
                    sibling.red = parent.red;
                    parent.red = false;
                    if (node.onLeft) {
                        assert (exists siblingRight=sibling.right, 
                        isRed(siblingRight));
                        siblingRight.red = false;
                        rotateLeft(parent);
                    }
                    else /*if (node.onRight)*/ {
                        assert (exists siblingLeft=sibling.left, 
                        isRed(siblingLeft));
                        siblingLeft.red = false;
                        rotateRight(parent);
                    }
                    //else {
                    //    assert (false);
                    //}
                }
            }
        }
    }
    
    shared void assertInvariants() {
        checkBlackRoot();
        checkColors();
        countBlackNodesInPaths();
    }
    
    void checkBlackRoot() {
        assert (!isRed(root));
    }
    
    void checkColors(Node<Key,Item>? node=root) {
        if (exists node) {
            if (isRed(node)) {
                assert (!isRed(node.left));
                assert (!isRed(node.right));
                assert (!isRed(node.parent));
            }
            checkColors(node.left);
            checkColors(node.right);
        }
    }
    
    Integer? countBlackNodesInPaths(node=root, blackCount=0, pathBlackCount=null) {
        Node<Key,Item>? node;
        variable Integer blackCount;
        variable Integer? pathBlackCount;
        if (!isRed(node)) {
            blackCount++;
        }
        if (exists node) {
            pathBlackCount = countBlackNodesInPaths(node.left, blackCount, pathBlackCount);
            pathBlackCount = countBlackNodesInPaths(node.right, blackCount, pathBlackCount);
            return pathBlackCount;
        }
        else {
            if (exists count=pathBlackCount) {
                assert (blackCount == count);
            }
            else {
                pathBlackCount = blackCount;
            }
            return pathBlackCount;
        }
    }
    
}

shared void testTree() {
    value tree = RBTree<String, String>();
    tree.assertInvariants();
    tree.put("hello", "hello");
    tree.assertInvariants();
    tree.put("world", "world");
    tree.assertInvariants();
    tree.put("goodbye", "goodbye");
    tree.assertInvariants();
    tree.put("0", "1");
    tree.assertInvariants();
    tree.put("gavin", "king");
    tree.assertInvariants();
    tree.put("2", "6");
    tree.assertInvariants();
    tree.put("@#", "%^");
    tree.assertInvariants();
    print(tree);
    tree.remove("hello");
    print(tree);
    tree.assertInvariants();
    tree.remove("@#");
    tree.assertInvariants();
    print(tree);
    tree.remove("world");
    tree.assertInvariants();
    print(tree);
}
