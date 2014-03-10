import ceylon.test { test, assertTrue, assertFalse, assertEquals }
import ceylon.collection { PriorityQueue, ArrayList }

shared test void testEmptyPriorityQueue() {
    value queue = newQueue();
    assertTrue(queue.empty);
}

shared test void testEmptyPriorityQueueAccept() {
    value queue = newQueue();
    assertEquals(queue.accept(), null);
}

shared test void testEmptyPriorityQueueFront() {
    value queue = newQueue();
    assertEquals(queue.front, null);
}

shared test void testEmptyPriorityQueueBack() {
    value queue = newQueue();
    assertEquals(queue.back, null);
}

shared test void testEmptyPriorityQueueLast() {
    value queue = newQueue();
    assertEquals(queue.last, null);
}

shared test void testPriorityQueueWithOneElement() {
    value queue = newQueue();
    queue.offer(7);
    assertFalse(queue.empty);
    assertEquals(queue.front, 7);
    assertFalse(queue.empty);
    assertEquals(queue.accept(), 7);
    assertTrue(queue.empty);
    assertEquals(queue.front, null);
    assertEquals(queue.accept(), null);
}

{Integer+} orderedValues = { -5, 1, 4, 5, 7, 8, 9 };
{Integer+} elementsIterable = { 7, 4, 5, 8, 1, 9, -5 };

shared test void testPriorityQueueWithSeveralElementsIterable() {
    value queue = newQueue(elementsIterable);
    checkEmptyQueue(queue, orderedValues);
}

shared test void testPriorityQueueWithSeveralElementsCollection() {
    value queue = newQueue(ArrayList { *elementsIterable });
    checkEmptyQueue(queue, orderedValues);
}

shared test void testPriorityQueueWithSeveralElementsSequence() {
    value queue = newQueue(elementsIterable.sequence);
    checkEmptyQueue(queue, orderedValues);
}

shared test void testOfferToPriorityQueue() {
    value queue = newQueue();
    variable Integer min = elementsIterable.first;
    for (element in elementsIterable) {
        if (min > element) {
            min = element;
        }
        queue.offer(element);
        assertEquals(queue.front, min);
    }
    checkEmptyQueue(queue, orderedValues);
}

shared test void testPriorityQueueIterable() {
    value queue = newQueue(elementsIterable);
    value sb = SequenceBuilder<Integer>();
    for (element in queue) {
        sb.append(element);
    }
    assertEquals(sb.sequence, [-5, 1, 5, 8, 4, 9, 7]);
}

PriorityQueue<Integer> newQueue({Integer*} elements = {}) => PriorityQueue {
    compare = (Integer first, Integer second) => first.compare(second);
    elements = elements;
};

void checkEmptyQueue(PriorityQueue<Integer> queue, {Integer*} orderedValues) {
    for (item in orderedValues) {
        assertFalse(queue.empty);
        assertEquals(queue.front, item);
        assert(exists last = queue.last);
        assertEquals(queue.last, queue.back);
        assertFalse(queue.empty);
        assertEquals(queue.accept(), item);
    }
    assertTrue(queue.empty);
    assertEquals(queue.front, null);
    assertEquals(queue.last, null);
    assertEquals(queue.back, null);
}
