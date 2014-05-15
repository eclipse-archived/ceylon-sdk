"A [[MutableMap]] implemented using a red/black tree.
 Entries in the map are maintained in a sorted order, from
 smallest to largest key, as determined by the given
 [[comparator function|compare]]."
see (`function naturalOrderTreeMap`)
by ("Gavin King")
shared class TreeMap<Key, Item>(compare, entries={})
        satisfies MutableMap<Key,Item>
                  & SortedMap<Key,Item>
                  & Ranged<Key,Key->Item,TreeMap<Key,Item>>
        given Key satisfies Object
        given Item satisfies Object {
    
    "A comparator function used to sort the entries."
    Comparison compare(Key x, Key y);
    
    "The initial entries in the map."
    {<Key->Item>*} entries;
    
    class Node(key, item) {
        
        shared variable Key key;
        shared variable Item item;
        shared variable Node? left=null;
        shared variable Node? right=null;
        shared variable Node? parent=null;
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
        
        shared Node? grandparent => parent?.parent;
        
        shared Node? sibling {
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
        
        shared Node? uncle => parent?.sibling;
        
        shared Node rightmostChild {
            variable value rightmost = this;
            while (exists right = rightmost.right) {
                rightmost = right;
            }
            return rightmost;
        }
        
        shared Node leftmostChild {
            variable value leftmost = this;
            while (exists left = leftmost.left) {
                leftmost = left;
            }
            return leftmost;
        }
        
        shared actual String string {
            value stringBuilder = StringBuilder();
            //stringBuilder.append("(");
            if (exists l=left) {
                stringBuilder.append(l.string).append(", ");
            }
            stringBuilder//.append(red then "[R]" else "[B]")
                    .append(key.string)
                    .append("->")
                    .append(item.string);
            if (exists r=right) {
                stringBuilder.append(", ").append(r.string);
            }
            //stringBuilder.append(")");
            return stringBuilder.string;
        }
        
        shared Node clone(TreeMap<Key,Item> clonedMap) {
            value clone = clonedMap.Node(key, item);
            if (exists left = this.left) {
                value leftClone = left.clone(clonedMap);
                clone.left = leftClone;
                leftClone.parent = clone;
            }
            if (exists right = this.right) {
                value rightClone = right.clone(clonedMap);
                clone.right = rightClone;
                rightClone.parent = clone;
            }
            return clone;
        }
        
        shared Integer size {
            variable Integer size = 1;
            if (exists left = this.left) {
                size+=left.size;
            }
            if (exists right = this.right) {
                size+=right.size;
            }
            return size;
        }
        
    }
    
    Boolean isRed(Node? node) {
        if (exists node) {
            return node.red;
        }
        else {
            return false;
        }
    }
    
    variable Node? root=null;
    
    function lookup(Key key) {
        variable value node = root;
        while (exists n=node) {
            switch (compare(key,n.key))
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
    
    function ceiling(Key key) {
        variable value node = root;
        while (exists n=node) {
            switch (compare(key,n.key))
            case (equal) {
                return n;
            }
            case (smaller) {
                if (!n.left exists) {
                    variable value child = n;
                    while (exists parent=child.parent,
                        child.onLeft) {
                        child=parent;
                    }
                    return child.parent;
                }
                node = n.left;
            }
            case (larger) {
                if (!n.right exists) {
                    return n;
                }
                node = n.right;
            }
        }
        return node;
    }
    
    function floor(Key key) {
        variable value node = root;
        while (exists n=node) {
            switch (compare(key,n.key))
            case (equal) {
                return n;
            }
            case (smaller) {
                if (!n.left exists) {
                    return n;
                }
                node = n.left;
            }
            case (larger) {
                if (!n.right exists) {
                    variable value child = n;
                    while (exists parent=child.parent,
                        child.onRight) {
                        child=parent;
                    }
                    return child.parent;
                }
                node = n.right;
            }
        }
        return node;
    }
    
    void replaceNode(Node old, Node? node) {
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

    void setLeftChild(Node node, Node? left) {
        node.left = left;
        if (exists left) {
            left.parent = node;
        }
    }

    void setRightChild(Node node, Node? right) {
        node.right = right;
        if (exists right) {
            right.parent = node;
        }
    }

    void rotateLeft(Node node) {
        assert (exists right = node.right);
        replaceNode(node, right);
        value rightLeft = right.left;
        setRightChild(node, rightLeft);
        setLeftChild(right, node);
    }

    void rotateRight(Node node) {
        assert (exists left = node.left);
        value leftRight = left.right;
        replaceNode(node, left);
        setLeftChild(node, leftRight);
        setRightChild(left, node);
    }

    void balanceAfterInsert(Node newNode) {
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
                    balanceAfterInsert(grandparent);
                }
                else {
                    //first rotation
                    Node adjustedNode;
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
    
    shared actual Item? put(Key key, Item item) {
        value newNode = Node(key, item);
        if (exists root=this.root) {
            variable Node node = root;
            while (true) {
                switch (compare(key,node.key))
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
                    Item oldItem = node.item;
                    node.item = item;
                    return oldItem;
                }
            }
            newNode.parent = node;
        }
        else {
            root = newNode;
        }
        balanceAfterInsert(newNode);
        return null;
    }

    for (key->item in entries) {
        put(key, item);
    }


    "Possible cases when removing nodes with at most one child"
    object removeCases {

        function getAndEnsureAtMostOneChild(TreeMap<Key,Item>.Node node) {
            if (exists left = node.left) {
                assert (!node.right exists);
                return left;
            }
            else if (exists right = node.right) {
                assert (!node.left exists);
                return right;
            }
            else {
                return null;
            }
        }

        shared void removeNodeWithAtMostOneChild(Node node) {
            value child = getAndEnsureAtMostOneChild(node);
            if (!node.red, isRed(child)) {
                assert(exists child);
                child.red = false;
            } else if (!node.red) {
                case1(node, node.sibling);
            }
            replaceNode(node, child);
        }

        void case1(Node node, Node? sibling) {
            if (exists r = root, !r === node) {
                case2(node, sibling);
            }
        }

        void case2(Node node, Node? sibling) {
            // not root, so child has a parent
            assert(exists p = node.parent);
            if (exists s = sibling, s.red) {
                p.red = true;
                s.red = false;
                if (node.onLeft) {
                    rotateLeft(p);
                } else {
                    rotateRight(p);
                }
            }
            value newParent = node.parent;
            assert(exists newParent);
            case3(node, newParent, node.sibling);
        }

        void case3(Node node, Node p, Node? s) {
            assert(exists s);
            value sLeftRed = isRed(s.left);
            value sRightRed = isRed(s.right);
            if (!s.red, !p.red, !sLeftRed, !sRightRed) {
                s.red = true;
                case1(p, p.sibling);
            } else {
                case4(node, p, s, sLeftRed, sRightRed);
            }
        }

        void case4(Node node, Node p, Node s, Boolean sLeftRed, Boolean sRightRed) {
            if (!s.red, p.red, !sLeftRed, !sRightRed) {
                s.red = true;
                p.red = false;
            } else {
                case5(node, p, s, sLeftRed, sRightRed);
            }
        }

        void case5(Node node, Node p, Node s, Boolean sLeftRed, Boolean sRightRed) {
            if (!s.red, sLeftRed, !sRightRed, node.onLeft) {
                s.red = true;
                assert (exists sl = s.left);
                sl.red = false;
                rotateRight(s);
            } else if (!s.red, !sLeftRed, sRightRed, node.onRight) {
                s.red = true;
                assert (exists sr = s.right);
                sr.red = false;
                rotateLeft(s);
            }
            value newParent = node.parent;
            value newS = node.sibling;
            assert(exists newParent, exists newS);
            case6(node, newParent, newS);
        }

        void case6(Node node, Node p, Node s) {
            s.red = p.red;
            p.red = false;
            if (node.onLeft, exists sr = s.right) {
                sr.red = false;
                rotateLeft(p);
            } else if (exists sl = s.left) {
                sl.red = false;
                rotateRight(p);
            }
        }

    }

    shared actual Item? remove(Key key) {
        if (exists result = lookup(key)) {
            Node node;
            if (exists left=result.left,
                exists right=result.right) {
                // Copy key/value from predecessor and then delete it instead
                node = left.rightmostChild;
                result.key = node.key;
                result.item = node.item;
            } else {
                node = result;
            }
            removeCases.removeNodeWithAtMostOneChild(node);
            return result.item;
        } else {
            return null;
        }
    }

    shared actual {<Key->Item>*} higherEntries(Key key) {
        object iterable satisfies {<Key->Item>*} {
            iterator() => NodeIterator(floor(key));
        }
        return iterable;
    }

    shared actual {<Key->Item>*} lowerEntries(Key key) {
        object iterable satisfies {<Key->Item>*} {
            iterator() => ReverseNodeIterator(ceiling(key));
        }
        return iterable;
    }

    class NodeIterator (current = root?.leftmostChild)
            satisfies Iterator<Key->Item> {
        variable Node? current;
        shared actual <Key->Item>|Finished next() {
            <Key->Item>|Finished entry;
            if (exists node=current) {
                entry = node.key->node.item;
            }
            else {
                entry = finished;
            }
            if (exists node=current,
            exists right=node.right) {
                current = right;
                while (exists left=current?.left) {
                    current = left;
                }
            }
            else if (exists node=current) {
                variable value child = node;
                while (exists parent=child.parent,
                    child.onRight) {
                    child = parent;
                }
                current = child.parent;
            }
            else {
                current = null;
            }
            return entry;
        }
    }
    
    class ReverseNodeIterator(current = root?.rightmostChild)
            satisfies Iterator<Key->Item> {
        variable Node? current;
        shared actual <Key->Item>|Finished next() {
            <Key->Item>|Finished entry;
            if (exists node=current) {
                entry = node.key->node.item;
            }
            else {
                entry = finished;
            }
            if (exists node=current,
                exists left=node.left) {
                current = left;
                while (exists right=current?.right) {
                    current = right;
                }
            }
            else if (exists node=current) {
                current = node.parent;
                variable value child = node;
                while (exists parent=current, child.onLeft) {
                    child = parent;
                    current = parent.parent;
                }
            }
            else {
                current = null;
            }
            return entry;
        }
    }
    
    shared actual Iterator<Key->Item> iterator()
            => NodeIterator();
    
    shared actual TreeMap<Key,Item> clone() {
        value clone = TreeMap<Key,Item>(compare);
        clone.root = root?.clone(clone);
        return clone;
    }
    
    shared actual <Item&Object>? get(Object key) {
        if (is Key key) {
            return lookup(key)?.item;
        }
        else {
            return null;
        }
    }
    
    clear() => root=null;
    
    size => root?.size else 0;
    
    shared actual String string {
        if (exists r=root) {
            return "{ " + r.string + " }";
        }
        else {
            return "{}";
        }
    }
    
    equals(Object that) => (super of Map<Key,Item>).equals(that);
    hash => (super of Map<Key,Item>).hash;
    
    shared void assertInvariants() {
        assertBlackRoot();
        assertColors();
        assertBlackNodesInPaths();
    }
    
    void assertBlackRoot() {
        assert (!isRed(root));
    }
    
    void assertColors(Node? node=root) {
        if (exists node) {
            if (isRed(node)) {
                assert (!isRed(node.left));
                assert (!isRed(node.right));
                assert (!isRed(node.parent));
            }
            assertColors(node.left);
            assertColors(node.right);
        }
    }
    
    Integer? assertBlackNodesInPaths(node=root, blackCount=0,
            pathBlackCount=null) {
        Node? node;
        variable Integer blackCount;
        variable Integer? pathBlackCount;
        if (!isRed(node)) {
            blackCount++;
        }
        if (exists node) {
            pathBlackCount = assertBlackNodesInPaths(node.left,
                    blackCount, pathBlackCount);
            pathBlackCount = assertBlackNodesInPaths(node.right,
                    blackCount, pathBlackCount);
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
    
    shared actual <Key->Item>? first {
        if (exists node = root?.leftmostChild) {
            return node.key->node.item;
        }
        return null;
    }
    
    shared actual <Key->Item>? last {
        if (exists node = root?.rightmostChild) {
            return node.key->node.item;
        }
        return null;
    }
    
    segment(Key from, Integer length)
            => TreeMap(compare, higherEntries(from).take(length));
    
    shared actual TreeMap<Key,Item> span(Key from, Key to) {
        {<Key->Item>*} entries;
        if (compare(from, to)==larger) {
            entries = lowerEntries(from)
                    takeWhile (Key->Item entry)
                            => compare(entry.key, to)!=smaller;
        }
        else {
            entries = higherEntries(from)
                    takeWhile (Key->Item entry)
                            => compare(entry.key, to)!=larger;
        }
        return TreeMap(compare, entries);
    }
    
    spanFrom(Key from)
            => TreeMap(compare, higherEntries(from));
    
    spanTo(Key to)
            => TreeMap(compare, takeWhile((Key->Item entry)
                    => compare(entry.key, to)!=larger));
    
}

"Create a [[TreeMap] with [[comparable|Comparable]]] keys,
 sorted by the natural ordering of the keys."
shared TreeMap<Key,Item> naturalOrderTreeMap<Key,Item>({<Key->Item>*} entries)
        given Key satisfies Comparable<Key>
        given Item satisfies Object
        => TreeMap((Key x, Key y) => x<=>y, entries);
