Boolean isRed<Key,Item>(Node<Key,Item>? node)
        given Key satisfies Comparable<Key> {
    if (exists node) {
        return node.red;
    }
    else {
        return false;
    }
}

Boolean onLeft<Key,Item>(Node<Key,Item> n)
        given Key satisfies Comparable<Key> {
    if (exists npl=n.parent?.left) {
        return n==npl;
    }
    else {
        return false;
    }
}

Boolean onRight<Key,Item>(Node<Key,Item> n)
        given Key satisfies Comparable<Key> {
    if (exists npl=n.parent?.right) {
        return n==npl;
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
    
    shared Node<Key,Item>? grandparent => parent?.parent;
    
    shared Node<Key,Item>? sibling {
        if (exists p=parent) { 
            if (onLeft(this)) {
                return p.right;
            }
            else if (onRight(this)){
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
        stringBuilder.append(key.string)
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
            if (onLeft(old)) {
                parent.left = node;
            }
            else if (onRight(old)) {
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
                    if (onRight(newNode) && onLeft(parent)) {
                        rotateLeft(parent);
                        assert (exists nl=newNode.left);
                        adjustedNode=nl;
                    } 
                    else if (onLeft(newNode) && onRight(parent)) {
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
                    if (onLeft(adjustedNode) && onLeft(adjustedParent)) {
                        rotateRight(grandparent);
                    }
                    else if (onRight(adjustedNode) && onRight(adjustedParent)) {
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
            if (exists child, !isRed(node)) {
                node.red = child.red;
                recolorAfterDeletion(node);
            }
            replaceNode(node, child);
        }
        //verifyProperties();
    }
    
    void recolorAfterDeletion(Node<Key,Item> node) {
        if (exists parent=node.parent,
            exists sibling=node.sibling) {
            if (isRed(sibling)) {
                parent.red = true;
                sibling.red = false;
                if (exists npl=parent.left, node == npl) {
                    rotateLeft(parent);
                }
                else {
                    rotateRight(parent);
                }
            }
            if (!isRed(sibling) &&
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
                if (exists siblingLeft=sibling.left,
                    onLeft(node) &&
                    !isRed(sibling) &&
                    isRed(sibling.left) &&
                    !isRed(sibling.right)) {
                    sibling.red = true;
                    siblingLeft.red = false;
                    rotateRight(sibling);
                }
                else if (exists siblingRight=sibling.right,
                    onRight(node) &&
                    !isRed(sibling) &&
                    isRed(sibling.right) &&
                    !isRed(sibling.left)) {
                    sibling.red = true;
                    siblingRight.red = false;
                    rotateLeft(sibling);
                }
                sibling.red = parent.red;
                parent.red = false;
                if (onLeft(node)) {
                    assert (exists siblingRight=sibling.right, 
                        isRed(siblingRight));
                    siblingRight.red = false;
                    rotateLeft(parent);
                }
                else if (onRight(node)) {
                    assert (exists siblingLeft=sibling.left, 
                        isRed(siblingLeft));
                    siblingLeft.red = false;
                    rotateRight(parent);
                }
                else {
                    assert (false);
                }
            }
        }
    }
    
}

//    verifyProperties();
//    shared void verifyProperties() {
//        if (VERIFY_RBTREE) {
//            verifyProperty1(root);
//            verifyProperty2(root);
//            // Property 3 is implicit
//            verifyProperty4(root);
//            verifyProperty5(root);
//        }
//    }
//    static void verifyProperty1(Node<?,?> n) {
//        assert nodeColor(n) == red || nodeColor(n) == black;
//        if (n == null) return;
//        verifyProperty1(n.left);
//        verifyProperty1(n.right);
//    }
//    static void verifyProperty2(Node<?,?> root) {
//        assert nodeColor(root) == black;
//    }
//    static Color nodeColor(Node<?,?> n) {
//        return n == null ? black : n.color;
//    }
//    static void verifyProperty4(Node<?,?> n) {
//        if (nodeColor(n) == red) {
//            assert nodeColor(n.left)   == black;
//            assert nodeColor(n.right)  == black;
//            assert nodeColor(n.parent) == black;
//        }
//        if (n == null) return;
//        verifyProperty4(n.left);
//        verifyProperty4(n.right);
//    }
//    static void verifyProperty5(Node<?,?> root) {
//        verifyProperty5Helper(root, 0, -1);
//    }
//
//    static int verifyProperty5Helper(Node<?,?> n, int blackCount, int pathBlackCount) {
//        if (nodeColor(n) == black) {
//            blackCount++;
//        }
//        if (n == null) {
//            if (pathBlackCount == -1) {
//                pathBlackCount = blackCount;
//            } else {
//                assert blackCount == pathBlackCount;
//            }
//            return pathBlackCount;
//        }
//        pathBlackCount = verifyProperty5Helper(n.left,  blackCount, pathBlackCount);
//        pathBlackCount = verifyProperty5Helper(n.right, blackCount, pathBlackCount);
//        return pathBlackCount;
//    }


shared void testTree() {
    value tree = RBTree<String, String>();
    tree.put("hello", "hello");
    tree.put("world", "world");
    tree.put("goodbye", "goodbye");
    tree.put("0", "1");
    tree.put("gavin", "king");
    tree.put("2", "6");
    tree.put("@#", "%^");
    print(tree);
    tree.remove("hello");
    tree.remove("@#");
    print(tree);
}
