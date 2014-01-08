abstract class Color() of red|black {}
object black extends Color() {}
object red extends Color() {}

Color nodeColor<Key,Item>(Node<Key,Item>? n)
        given Key satisfies Comparable<Key>
        => n?.color else black;

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

    function lookupNode(Key key) {
        variable value nn = root;
        while (exists n=nn) {
            value compResult = key<=>n.key;
            switch (compResult) 
            case (equal) {
                return n;
            } 
            case (smaller) {
                nn = n.left;
            }
            case (larger) {
                nn = n.right;
            }
        }
        return nn;
    }
    
    shared Item? get(Key key) => lookupNode(key)?.item;
    
    void replaceNode(Node<Key,Item> oldn, Node<Key,Item>? newn) {
        if (exists op=oldn.parent) {
            if (exists opl=op.left, oldn == opl) {
                op.left = newn;
            }
            else {
                op.right = newn;
            }
        }
        else {
            root = newn;
        }
        if (exists newn) {
            newn.parent = oldn.parent;
        }
    }
    
    void rotateLeft(Node<Key,Item> n) {
        assert (exists r = n.right);
        replaceNode(n, r);
        n.right = r.left;
        if (exists rl=r.left) {
            rl.parent = n;
        }
        r.left = n;
        n.parent = r;
    }

    void rotateRight(Node<Key,Item> n) {
        assert (exists l = n.left);
        replaceNode(n, l);
        n.left = l.right;
        if (exists lr = l.right) {
            lr.parent = n;
        }
        l.right = n;
        n.parent = l;
    }
    
    shared void put(Key key, Item item) {
        Node<Key,Item> insertedNode = Node<Key,Item>(key, item, red);
        if (exists r=root) {
            variable Node<Key,Item> n = r;
            while (true) {
                value compResult = key<=>n.key;
                switch (compResult)
                case (larger) {
                    if (exists nr=n.right) {
                        n = nr;
                    } else {
                        n.right = insertedNode;
                        break;
                    }
                }
                case (smaller) {
                    if (exists nl = n.left) {
                        n = nl;
                    } else {
                        n.left = insertedNode;
                        break;
                    }
                }
                case (equal) {
                    n.item = item;
                    return;
                }
            }
            insertedNode.parent = n;
        }
        else {
            root = insertedNode;
        }
        insertCase1(insertedNode);
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
        if (nodeColor(n.parent) != black) {
            insertCase3(n);
        }
    }
    
    void insertCase3(Node<Key,Item> n) {
        if (nodeColor(n.uncle) == red) {
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
    
    Node<Key,Item> maximumNode(Node<Key,Item> n) {
        variable value nn = n;
        while (exists nr = nn.right) {
            nn = nr;
        }
        return nn;
    }
    
    shared void remove(Key key) {
        if (exists n = lookupNode(key)) {
            Node<Key,Item> nn;
            if (exists nl=n.left, exists nr=n.right) {
                // Copy key/value from predecessor and then delete it instead
                Node<Key,Item> pred = maximumNode(nl);
                n.key = pred.key;
                n.item = pred.item;
                nn = pred;
            }
            else {
                nn = n;
            }
            
            Node<Key,Item> child;
            if (exists nl = nn.left) {
                child = nl;
            }
            else if (exists nr = nn.right) {
                child = nr;
            }
            else {
                assert (false);
            }
            if (nodeColor(n) == black) {
                n.color = nodeColor(child);
                deleteCase1(n);
            }
            replaceNode(n, child);
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
            nodeColor(ns) == red) {
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
            nodeColor(np) == black &&
            nodeColor(ns) == black &&
            nodeColor(ns.left) == black &&
            nodeColor(ns.right) == black)
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
            nodeColor(np) == red &&
            nodeColor(ns) == black &&
            nodeColor(ns.left) == black &&
            nodeColor(ns.right) == black)
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
            nodeColor(ns) == black &&
            nodeColor(ns.left) == red &&
            nodeColor(ns.right) == black)
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
            nodeColor(ns) == black &&
            nodeColor(ns.right) == red &&
            nodeColor(ns.left) == black)
        {
            ns.color = red;
            nsr.color = black;
            rotateLeft(ns);
        }
        deleteCase6(n);
    }
    
    void deleteCase6(Node<Key,Item> n) {
        assert (exists ns=n.sibling, exists np=n.parent);
        ns.color = nodeColor(np);
        np.color = black;
        if (exists npl = np.left, n == npl) {
            assert (exists nsr=ns.right, nodeColor(nsr) == red);
            nsr.color = black;
            rotateLeft(np);
        }
        else
        {
            assert (exists nsl=ns.left, nodeColor(ns.left) == red);
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
}
