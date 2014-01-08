abstract class Color() of red|black {}
object black extends Color() {}
object red extends Color() {}

Boolean isRed<Key,Item>(Node<Key,Item>? node)
        given Key satisfies Comparable<Key> {
    if (exists node) {
        return node.color==red;
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

class Node<Key,Item>(key, item, color) 
        given Key satisfies Comparable<Key>
{
    shared variable Key key;
    shared variable Item item;
    shared variable Node<Key,Item>? left=null;
    shared variable Node<Key,Item>? right=null;
    shared variable Node<Key,Item>? parent=null;
    shared variable Color color;
    
    shared Node<Key,Item> grandparent {
        assert (exists p=parent); // Not the root node
        assert (exists gp=p.parent); // Not child of root
        return gp;
    }
    shared Node<Key,Item>? sibling {
        assert (exists p=parent); // Root node has no sibling
        if (exists l=p.left, this==l) {
            return p.right;
        }
        else {
            return p.left;
        }
    }
    
    shared Node<Key,Item>? uncle {
        assert (exists p=parent); // Root node has no uncle
        assert (exists gp=p.parent); // Children of root have no uncle
        return p.sibling;
    }
    
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
        given Key satisfies Comparable<Key>
{
    //shared static final boolean VERIFY_RBTREE = true;
    //static final int INDENT_STEP = 4;
    
    variable Node<Key,Item>? root=null;

    shared actual String string {
        if (exists r=root) {
            return "{ " + r.string + " }";
        }
        else {
            return "{}";
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
        value newNode = Node(key, item, red);
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
        insertCase1(newNode);
        //verifyProperties();
    }
    
    void insertCase1(Node<Key,Item> n) {
        if (n.parent exists) {
            insertCase2(n);
        }
        else {
            n.color = black;
        }
    }
    
    void insertCase2(Node<Key,Item> n) {
        if (isRed(n.parent)) {
            insertCase3(n);
        }
    }
    
    void insertCase3(Node<Key,Item> n) {
        if (isRed(n.uncle)) {
            assert (exists np=n.parent);
            assert (exists nu=n.uncle);
            np.color = black;
            nu.color = black;
            n.grandparent.color = red;
            insertCase1(n.grandparent);
        } else {
            insertCase4(n);
        }
    }
    
    void insertCase4(Node<Key,Item> n) {
        assert (exists np=n.parent);
        Node<Key,Item>? nn;
        if (exists npr=np.right, 
            exists ngl= n.grandparent.left, 
            n == npr && np == ngl) {
            rotateLeft(np);
            nn = n.left;
        } 
        else if (exists npl=np.left, 
            exists ngr= n.grandparent.right, 
            n == npl && np == ngr) {
            rotateRight(np);
            nn = n.right;
        }
        else {
            nn = n;
        }
        assert (exists nn);
        insertCase5(n);
    }
    
    void insertCase5(Node<Key,Item> n) {
        assert (exists np=n.parent);
        np.color = black;
        n.grandparent.color = red;
        if (exists npl=np.left, 
            exists ngl= n.grandparent.left,
            n == npl && np == ngl) {
            rotateRight(n.grandparent);
        }
        else {
            assert (exists npr=np.right, 
                exists ngr= n.grandparent.right,
                n == npr && np == ngr);
            rotateLeft(n.grandparent);
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
        if (exists node = lookup(key)) {
            Node<Key,Item> adjusted;
            if (exists left=node.left, exists right=node.right) {
                // Copy key/value from predecessor and then delete it instead
                Node<Key,Item> rightmost = rightmostChild(left);
                node.key = rightmost.key;
                node.item = rightmost.item;
                adjusted = rightmost;
            }
            else {
                adjusted = node;
            }
            
            Node<Key,Item>? child;
            if (exists left = adjusted.left) {
                child = left;
            }
            else if (exists right = adjusted.right) {
                child = right;
            }
            else {
                child = null;
            }
            if (exists child, !isRed(node)) {
                node.color = child.color;
                deleteCase1(node);
            }
            replaceNode(node, child);
        }
        //verifyProperties();
    }
    
    void deleteCase1(Node<Key,Item> n) {
        if (n.parent exists) {
            deleteCase2(n);
        }
    }
    
    void deleteCase2(Node<Key,Item> n) {
        if (exists np=n.parent, 
            exists ns=n.sibling, 
            isRed(ns)) {
            np.color = red;
            ns.color = black;
            if (exists npl=np.left, n == npl) {
                rotateLeft(np);
            }
            else {
                rotateRight(np);
            }
        }
        deleteCase3(n);
    }
    
    void deleteCase3(Node<Key,Item> n) {
        if (exists np=n.parent, 
            exists ns=n.sibling,
            !isRed(np) &&
            !isRed(ns) &&
            !isRed(ns.left) &&
            !isRed(ns.right))
        {
            ns.color = red;
            deleteCase1(np);
        }
        else {
            deleteCase4(n);
        }
    }
    
    void deleteCase4(Node<Key,Item> n) {
        if (exists np=n.parent, 
            exists ns=n.sibling,
            isRed(np) &&
            !isRed(ns) &&
            !isRed(ns.left) &&
            !isRed(ns.right))
        {
            ns.color = red;
            np.color = black;
        }
        else {
            deleteCase5(n);
        }
    }
    
    void deleteCase5(Node<Key,Item> n) {
        if (exists np=n.parent,
            exists ns=n.sibling,
            exists npl=np.left,
            exists nsl=ns.left,
            n == npl &&
            !isRed(ns) &&
            isRed(ns.left) &&
            !isRed(ns.right))
        {
            ns.color = red;
            nsl.color = black;
            rotateRight(ns);
        }
        else if (exists np=n.parent,
            exists ns=n.sibling,
            exists npr=np.right,
            exists nsr=ns.left,
            n == npr &&
            !isRed(ns) &&
            isRed(ns.right) &&
            !isRed(ns.left))
        {
            ns.color = red;
            nsr.color = black;
            rotateLeft(ns);
        }
        deleteCase6(n);
    }
    
    void deleteCase6(Node<Key,Item> n) {
        assert (exists ns=n.sibling, exists np=n.parent);
        ns.color = np.color;
        np.color = black;
        if (exists npl = np.left, n == npl) {
            assert (exists nsr=ns.right, isRed(nsr));
            nsr.color = black;
            rotateLeft(np);
        }
        else
        {
            assert (exists nsl=ns.left, isRed(ns.left));
            nsl.color = black;
            rotateRight(np);
        }
    }
    
}


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
