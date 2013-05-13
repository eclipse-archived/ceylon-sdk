
import ceylon.test { suite, assertEquals }
import ceylon.time.internal { overlap, gap }

Integer a = 1;
Integer b = 2;
Integer c = 3;
Integer d = 4;
Integer e = 5;
Integer f = 6;

shared void runUtilTests(){
    testOverlapFunction();
    testGapFunction();
}

void testOverlapFunction() {
    suite("Testing overlap function", 
        // no overlap
        "Testing overlap: [a, b] U [c, d] is Empty" -> test_ab_overlap_cd_is_empty,
        "Testing overlap: [b, a] U [c, d] is Empty" -> test_ba_overlap_cd_is_empty,
        "Testing overlap: [a, b] U [d, c] is Empty" -> test_ab_overlap_dc_is_empty,
        "Testing overlap: [b, a] U [d, c] is Empty" -> test_ba_overlap_dc_is_empty,
        "Testing overlap: [c, d] U [a, b] is Empty" -> test_cd_overlap_ab_is_empty,
        "Testing overlap: [d, c] U [a, b] is Empty" -> test_dc_overlap_ab_is_empty,
        "Testing overlap: [c, d] U [b, a] is Empty" -> test_cd_overlap_ba_is_empty,
        "Testing overlap: [d, c] U [b, a] is Empty" -> test_dc_overlap_ba_is_empty,
        // simple overlap
        "Testing overlap: [a, c] U [b, d] == [b, c]" -> test_ac_overlap_bd_is_bc,
        "Testing overlap: [c, a] U [b, d] == [b, c]" -> test_ca_overlap_bd_is_bc,
        "Testing overlap: [a, c] U [d, b] == [b, c]" -> test_ac_overlap_db_is_bc,
        "Testing overlap: [c, a] U [d, b] == [b, c]" -> test_ca_overlap_db_is_bc,
        "Testing overlap: [b, d] U [a, c] == [b, c]" -> test_bd_overlap_ac_is_bc,
        "Testing overlap: [d, b] U [a, c] == [b, c]" -> test_db_overlap_ac_is_bc,
        "Testing overlap: [b, d] U [c, a] == [b, c]" -> test_bd_overlap_ca_is_bc,
        "Testing overlap: [d, b] U [c, a] == [b, c]" -> test_db_overlap_ca_is_bc,
        // one point overlap
        "Testing overlap: [a, b] U [b, c] == [b, b]" -> test_ab_overlap_bc_is_bb,
        "Testing overlap: [b, a] U [b, c] == [b, b]" -> test_ba_overlap_bc_is_bb,
        "Testing overlap: [a, b] U [c, b] == [b, b]" -> test_ab_overlap_cb_is_bb,
        "Testing overlap: [b, a] U [c, b] == [b, b]" -> test_ba_overlap_cb_is_bb,
        "Testing overlap: [c, c] U [a, b] == [b, b]" -> test_bc_overlap_ab_is_bb,
        "Testing overlap: [d, b] U [a, b] == [b, b]" -> test_cb_overlap_ab_is_bb,
        "Testing overlap: [b, c] U [b, a] == [b, b]" -> test_bc_overlap_ba_is_bb,
        "Testing overlap: [c, b] U [b, a] == [b, b]" -> test_cb_overlap_ba_is_bb,
        // subset overlap
        "Testing overlap: [a, d] U [b, c] == [b, c]" -> test_ad_overlap_bc_is_bc,
        "Testing overlap: [d, a] U [b, c] == [b, c]" -> test_da_overlap_bc_is_bc,
        "Testing overlap: [a, d] U [c, b] == [b, c]" -> test_ad_overlap_cb_is_bc,
        "Testing overlap: [d, a] U [c, b] == [b, c]" -> test_da_overlap_cb_is_bc,
        "Testing overlap: [b, c] U [a, d] == [b, c]" -> test_bc_overlap_ad_is_bc,
        "Testing overlap: [c, b] U [a, d] == [b, c]" -> test_cb_overlap_ad_is_bc,
        "Testing overlap: [b, c] U [d, a] == [b, c]" -> test_bc_overlap_da_is_bc,
        "Testing overlap: [c, b] U [d, a] == [b, c]" -> test_cb_overlap_da_is_bc
    );
}

// Empty overlap cases
shared void test_ab_overlap_cd_is_empty() => assertEquals(empty, overlap([a, b], [c, d]));
shared void test_ba_overlap_cd_is_empty() => assertEquals(empty, overlap([b, a], [c, d]));
shared void test_ab_overlap_dc_is_empty() => assertEquals(empty, overlap([a, b], [d, c]));
shared void test_ba_overlap_dc_is_empty() => assertEquals(empty, overlap([b, a], [d, c]));
shared void test_cd_overlap_ab_is_empty() => assertEquals(empty, overlap([c, d], [a, b]));
shared void test_dc_overlap_ab_is_empty() => assertEquals(empty, overlap([d, c], [a, b]));
shared void test_cd_overlap_ba_is_empty() => assertEquals(empty, overlap([c, d], [b, a]));
shared void test_dc_overlap_ba_is_empty() => assertEquals(empty, overlap([d, c], [b, a]));

// simple partial overlap cases
shared void test_ac_overlap_bd_is_bc() => assertEquals([b, c], overlap([a, c], [b, d]));
shared void test_ca_overlap_bd_is_bc() => assertEquals([b, c], overlap([c, a], [b, d]));
shared void test_ac_overlap_db_is_bc() => assertEquals([b, c], overlap([a, c], [d, b]));
shared void test_ca_overlap_db_is_bc() => assertEquals([b, c], overlap([c, a], [d, b]));
shared void test_bd_overlap_ac_is_bc() => assertEquals([b, c], overlap([b, d], [a, c]));
shared void test_db_overlap_ac_is_bc() => assertEquals([b, c], overlap([d, b], [a, c]));
shared void test_bd_overlap_ca_is_bc() => assertEquals([b, c], overlap([b, d], [c, a]));
shared void test_db_overlap_ca_is_bc() => assertEquals([b, c], overlap([d, b], [c, a]));

// one element partial overlap cases
shared void test_ab_overlap_bc_is_bb() => assertEquals([b, b], overlap([a, b], [b, c]));
shared void test_ba_overlap_bc_is_bb() => assertEquals([b, b], overlap([b, a], [b, c]));
shared void test_ab_overlap_cb_is_bb() => assertEquals([b, b], overlap([a, b], [c, b]));
shared void test_ba_overlap_cb_is_bb() => assertEquals([b, b], overlap([b, a], [c, b]));
shared void test_bc_overlap_ab_is_bb() => assertEquals([b, b], overlap([b, c], [a, b]));
shared void test_cb_overlap_ab_is_bb() => assertEquals([b, b], overlap([c, b], [a, b]));
shared void test_bc_overlap_ba_is_bb() => assertEquals([b, b], overlap([b, c], [b, a]));
shared void test_cb_overlap_ba_is_bb() => assertEquals([b, b], overlap([c, b], [b, a]));

// full encasement overlap (subset) cases
shared void test_ad_overlap_bc_is_bc() => assertEquals([b, c], overlap([a, d], [b, c]));
shared void test_da_overlap_bc_is_bc() => assertEquals([b, c], overlap([d, a], [b, c]));
shared void test_ad_overlap_cb_is_bc() => assertEquals([b, c], overlap([a, d], [c, b]));
shared void test_da_overlap_cb_is_bc() => assertEquals([b, c], overlap([d, a], [c, b]));
shared void test_bc_overlap_ad_is_bc() => assertEquals([b, c], overlap([b, c], [a, d]));
shared void test_cb_overlap_ad_is_bc() => assertEquals([b, c], overlap([c, b], [a, d]));
shared void test_bc_overlap_da_is_bc() => assertEquals([b, c], overlap([b, c], [d, a]));
shared void test_cb_overlap_da_is_bc() => assertEquals([b, c], overlap([c, b], [d, a]));


void testGapFunction(){
    suite("Testing gap function",
        // overlapping ranges
        "Testing gap: [1, 3]..[2, 4] is Empty" -> assertGapEquals(empty, [1, 3], [2, 4]),
        "Testing gap: [3, 1]..[2, 4] is Empty" -> assertGapEquals(empty, [3, 1], [2, 4]),
        "Testing gap: [1, 3]..[4, 2] is Empty" -> assertGapEquals(empty, [1, 3], [4, 2]),
        "Testing gap: [3, 1]..[4, 2] is Empty" -> assertGapEquals(empty, [3, 1], [4, 2]),
        "Testing gap: [2, 4]..[1, 3] is Empty" -> assertGapEquals(empty, [2, 4], [1, 3]),
        "Testing gap: [4, 2]..[1, 3] is Empty" -> assertGapEquals(empty, [4, 2], [1, 3]),
        "Testing gap: [2, 4]..[3, 1] is Empty" -> assertGapEquals(empty, [2, 4], [3, 1]),
        "Testing gap: [4, 2]..[3, 1] is Empty" -> assertGapEquals(empty, [4, 2], [3, 1]),
        // simple gap
        "Testing gap: [1, 2]..[3, 4] == [2, 3]" -> assertGapEquals([2, 3], [1, 2], [3, 4]),
        "Testing gap: [2, 1]..[3, 4] == [2, 3]" -> assertGapEquals([2, 3], [2, 1], [3, 4]),
        "Testing gap: [1, 2]..[4, 3] == [2, 3]" -> assertGapEquals([2, 3], [1, 2], [4, 3]),
        "Testing gap: [2, 1]..[4, 3] == [2, 3]" -> assertGapEquals([2, 3], [2, 1], [4, 3]),
        "Testing gap: [3, 4]..[1, 2] == [2, 3]" -> assertGapEquals([2, 3], [3, 4], [1, 2]),
        "Testing gap: [4, 3]..[1, 2] == [2, 3]" -> assertGapEquals([2, 3], [4, 3], [1, 2]),
        "Testing gap: [3, 4]..[2, 1] == [2, 3]" -> assertGapEquals([2, 3], [3, 4], [2, 1]),
        "Testing gap: [4, 3]..[2, 1] == [2, 3]" -> assertGapEquals([2, 3], [4, 3], [2, 1]),
        // empty gap
        "Testing gap: [1, 2]..[2, 3] is Empty" -> assertGapEquals(empty, [1, 2], [2, 3]),
        "Testing gap: [2, 1]..[2, 3] is Empty" -> assertGapEquals(empty, [2, 1], [2, 3]),
        "Testing gap: [1, 2]..[3, 2] is Empty" -> assertGapEquals(empty, [1, 2], [3, 2]),
        "Testing gap: [2, 1]..[3, 2] is Empty" -> assertGapEquals(empty, [2, 1], [3, 2]),
        "Testing gap: [3, 2]..[1, 2] is Empty" -> assertGapEquals(empty, [3, 2], [1, 2]),
        "Testing gap: [2, 3]..[1, 2] is Empty" -> assertGapEquals(empty, [2, 3], [1, 2]),
        "Testing gap: [3, 2]..[2, 1] is Empty" -> assertGapEquals(empty, [3, 2], [2, 1]),
        "Testing gap: [2, 3]..[2, 1] is Empty" -> assertGapEquals(empty, [2, 3], [2, 1])
    );
}

void assertGapEquals<Value>([Value, Value]|Empty expected, [Value, Value] first, [Value, Value] second)()
              given Value satisfies Comparable<Value> & Ordinal<Value>{
    assertEquals(expected, gap(first, second));
}
