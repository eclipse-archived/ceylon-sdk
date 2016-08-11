import ceylon.buffer {
    Buffer
}
import ceylon.test {
    test,
    assertEquals,
    assertNotEquals
}

shared abstract class BufferTests<Element>() {
    shared formal Buffer<Element>({Element*}) bufferOfData;
    shared formal Buffer<Element>(Array<Element>) bufferOfArray;
    shared formal Buffer<Element>(Integer) bufferOfSize;
    
    shared formal Array<Element> zeroSizeSample;
    shared formal Array<Element> oneSizeSample;
    shared formal Array<Element> twoSizeSample;
    shared formal Array<Element> threeSizeSample;
    shared formal Array<Element> largeSample;
    
    shared Buffer<Element> bufferOfDataEmpty => bufferOfData(zeroSizeSample);
    shared Buffer<Element> bufferOfDataOne => bufferOfData(oneSizeSample);
    shared Buffer<Element> bufferOfDataTwo => bufferOfData(twoSizeSample);
    shared Buffer<Element> bufferOfDataThree => bufferOfData(threeSizeSample);
    shared Buffer<Element> bufferOfDataLarge => bufferOfData(largeSample);
    
    shared Buffer<Element> bufferOfArrayEmpty => bufferOfArray(zeroSizeSample);
    shared Buffer<Element> bufferOfArrayOne => bufferOfArray(oneSizeSample);
    shared Buffer<Element> bufferOfArrayTwo => bufferOfArray(twoSizeSample);
    shared Buffer<Element> bufferOfArrayThree => bufferOfArray(threeSizeSample);
    shared Buffer<Element> bufferOfArrayLarge => bufferOfArray(largeSample);
    
    test
    shared void sampleEquality() {
        value ofDataSamples = [bufferOfDataEmpty, bufferOfDataOne, bufferOfDataTwo,
            bufferOfDataThree, bufferOfDataLarge];
        value ofArraySamples = [bufferOfArrayEmpty, bufferOfArrayOne, bufferOfArrayTwo,
            bufferOfArrayThree, bufferOfArrayLarge];
        value sampleGroups = [ofDataSamples, ofArraySamples];
        
        for (g1->sampleGroup1 in sampleGroups.indexed) {
            for (g2->sampleGroup2 in sampleGroups.indexed) {
                for (i in 0..5) {
                    assertEquals {
                        sampleGroup1[i];
                        sampleGroup2[i];
                        "Group: ``g1``,``g2`` Sample: ``i``";
                    };
                }
            }
        }
    }
    
    test
    shared void inequality() {
        assertNotEquals(bufferOfDataEmpty, bufferOfDataOne);
        assertNotEquals(bufferOfDataOne, bufferOfDataTwo);
        value posBuffer = bufferOfDataThree;
        posBuffer.position = 1;
        assertNotEquals(posBuffer, bufferOfDataTwo);
        assertNotEquals(posBuffer, bufferOfDataThree);
        assertNotEquals(bufferOfDataLarge, bufferOfData(largeSample.reversed));
    }
    
    void assertEmpty(Buffer<Element> buffer) {
        assertEquals(buffer.capacity, 0);
        assertEquals(buffer.limit, 0);
        assertEquals(buffer.position, 0);
        assertEquals(buffer.available, 0);
        assertEquals(buffer.hasAvailable, false);
    }
    
    test
    shared void ofDataEmpty() {
        value buffer = bufferOfDataEmpty;
        assertEmpty(buffer);
        buffer.clear();
        assertEmpty(buffer);
        buffer.flip();
        assertEmpty(buffer);
        buffer.clear();
        assertEmpty(buffer);
    }
    
    test
    shared void ofArrayEmpty() {
        value buffer = bufferOfArrayEmpty;
        assertEmpty(buffer);
        buffer.clear();
        assertEmpty(buffer);
        buffer.flip();
        assertEmpty(buffer);
        buffer.clear();
        assertEmpty(buffer);
    }
    
    test
    shared void ofSizeEmpty() {
        value buffer = bufferOfSize(0);
        assertEmpty(buffer);
        buffer.clear();
        assertEmpty(buffer);
        buffer.flip();
        assertEmpty(buffer);
        buffer.clear();
        assertEmpty(buffer);
    }
    
    void assertSizedInitial(Buffer<Element> buffer, Integer size) {
        assertEquals(buffer.capacity, size);
        assertEquals(buffer.limit, size);
        assertEquals(buffer.position, 0);
        assertEquals(buffer.available, size);
        assertEquals(buffer.hasAvailable, true);
    }
    void assertSizedFlip(Buffer<Element> buffer, Integer size) {
        assertEquals(buffer.capacity, size);
        assertEquals(buffer.limit, 0);
        assertEquals(buffer.position, 0);
        assertEquals(buffer.available, 0);
        assertEquals(buffer.hasAvailable, false);
    }
    
    test
    shared void ofSizeOne() {
        value buffer = bufferOfSize(1);
        assertSizedInitial(buffer, 1);
        buffer.clear();
        assertSizedInitial(buffer, 1);
        buffer.flip();
        assertSizedFlip(buffer, 1);
        buffer.clear();
        assertSizedInitial(buffer, 1);
    }
    
    test
    shared void visibleArrayZero() {
        value buffer = bufferOfSize(0);
        assertEquals(buffer.visible.size, 0);
        buffer.flip();
        assertEquals(buffer.visible.size, 0);
    }
    
    test
    shared void visibleArrayOne() {
        value buffer = bufferOfSize(1);
        assertEquals(buffer.visible.size, 1);
        buffer.flip();
        assertEquals(buffer.visible.size, 0);
        buffer.clear();
        for (data in oneSizeSample) {
            buffer.put(data);
        }
        buffer.flip();
        assertEquals(buffer.visible, oneSizeSample);
    }
    
    test
    shared void visibleArrayTwo() {
        value buffer = bufferOfSize(2);
        assertEquals(buffer.visible.size, 2);
        buffer.flip();
        assertEquals(buffer.visible.size, 0);
        buffer.clear();
        for (data in oneSizeSample) {
            buffer.put(data);
        }
        buffer.flip();
        assertEquals(buffer.visible, oneSizeSample);
        buffer.clear();
        for (data in twoSizeSample) {
            buffer.put(data);
        }
        buffer.flip();
        assertEquals(buffer.visible, twoSizeSample);
    }
    
    test
    shared void visibleArrayThree() {
        value buffer = bufferOfSize(3);
        assertEquals(buffer.visible.size, 3);
        buffer.flip();
        assertEquals(buffer.visible.size, 0);
        buffer.clear();
        for (data in threeSizeSample) {
            buffer.put(data);
        }
        buffer.flip();
        buffer.get();
        assertEquals(buffer.visible, Array(threeSizeSample.skip(1)));
    }
    
    test
    shared void sharedArray() {
        value buffer = bufferOfSize(1);
        oneSizeSample.copyTo(buffer.array);
        assertEquals(buffer.array, oneSizeSample);
    }
}
