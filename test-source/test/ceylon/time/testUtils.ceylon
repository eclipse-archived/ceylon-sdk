
import ceylon.test {
    assertEquals,
    test
}
import ceylon.time.internal {
    overlap,
    gap
}

Integer a = 1;
Integer b = 2;
Integer c = 3;
Integer d = 4;
Integer e = 5;
Integer f = 6;


// Empty overlap cases
shared test void test_ab_overlap_cd_is_empty() => assertEquals(empty, overlap([a, b], [c, d]));
shared test void test_ba_overlap_cd_is_empty() => assertEquals(empty, overlap([b, a], [c, d]));
shared test void test_ab_overlap_dc_is_empty() => assertEquals(empty, overlap([a, b], [d, c]));
shared test void test_ba_overlap_dc_is_empty() => assertEquals(empty, overlap([b, a], [d, c]));
shared test void test_cd_overlap_ab_is_empty() => assertEquals(empty, overlap([c, d], [a, b]));
shared test void test_dc_overlap_ab_is_empty() => assertEquals(empty, overlap([d, c], [a, b]));
shared test void test_cd_overlap_ba_is_empty() => assertEquals(empty, overlap([c, d], [b, a]));
shared test void test_dc_overlap_ba_is_empty() => assertEquals(empty, overlap([d, c], [b, a]));

// simple partial overlap cases
shared test void test_ac_overlap_bd_is_bc() => assertEquals([b, c], overlap([a, c], [b, d]));
shared test void test_ca_overlap_bd_is_bc() => assertEquals([b, c], overlap([c, a], [b, d]));
shared test void test_ac_overlap_db_is_bc() => assertEquals([b, c], overlap([a, c], [d, b]));
shared test void test_ca_overlap_db_is_bc() => assertEquals([b, c], overlap([c, a], [d, b]));
shared test void test_bd_overlap_ac_is_bc() => assertEquals([b, c], overlap([b, d], [a, c]));
shared test void test_db_overlap_ac_is_bc() => assertEquals([b, c], overlap([d, b], [a, c]));
shared test void test_bd_overlap_ca_is_bc() => assertEquals([b, c], overlap([b, d], [c, a]));
shared test void test_db_overlap_ca_is_bc() => assertEquals([b, c], overlap([d, b], [c, a]));

// one element partial overlap cases
shared test void test_ab_overlap_bc_is_bb() => assertEquals([b, b], overlap([a, b], [b, c]));
shared test void test_ba_overlap_bc_is_bb() => assertEquals([b, b], overlap([b, a], [b, c]));
shared test void test_ab_overlap_cb_is_bb() => assertEquals([b, b], overlap([a, b], [c, b]));
shared test void test_ba_overlap_cb_is_bb() => assertEquals([b, b], overlap([b, a], [c, b]));
shared test void test_bc_overlap_ab_is_bb() => assertEquals([b, b], overlap([b, c], [a, b]));
shared test void test_cb_overlap_ab_is_bb() => assertEquals([b, b], overlap([c, b], [a, b]));
shared test void test_bc_overlap_ba_is_bb() => assertEquals([b, b], overlap([b, c], [b, a]));
shared test void test_cb_overlap_ba_is_bb() => assertEquals([b, b], overlap([c, b], [b, a]));

// full encasement overlap (subset) cases
shared test void test_ad_overlap_bc_is_bc() => assertEquals([b, c], overlap([a, d], [b, c]));
shared test void test_da_overlap_bc_is_bc() => assertEquals([b, c], overlap([d, a], [b, c]));
shared test void test_ad_overlap_cb_is_bc() => assertEquals([b, c], overlap([a, d], [c, b]));
shared test void test_da_overlap_cb_is_bc() => assertEquals([b, c], overlap([d, a], [c, b]));
shared test void test_bc_overlap_ad_is_bc() => assertEquals([b, c], overlap([b, c], [a, d]));
shared test void test_cb_overlap_ad_is_bc() => assertEquals([b, c], overlap([c, b], [a, d]));
shared test void test_bc_overlap_da_is_bc() => assertEquals([b, c], overlap([b, c], [d, a]));
shared test void test_cb_overlap_da_is_bc() => assertEquals([b, c], overlap([c, b], [d, a]));


shared test void testGapFunction(){
    assertGapEquals(empty, [1, 3], [2, 4]);
    assertGapEquals(empty, [3, 1], [2, 4]);
    assertGapEquals(empty, [1, 3], [4, 2]);
    assertGapEquals(empty, [3, 1], [4, 2]);
    assertGapEquals(empty, [2, 4], [1, 3]);
    assertGapEquals(empty, [4, 2], [1, 3]);
    assertGapEquals(empty, [2, 4], [3, 1]);
    assertGapEquals(empty, [4, 2], [3, 1]);
    
    assertGapEquals([2, 3], [1, 2], [3, 4]);
    assertGapEquals([2, 3], [2, 1], [3, 4]);
    assertGapEquals([2, 3], [1, 2], [4, 3]);
    assertGapEquals([2, 3], [2, 1], [4, 3]);
    assertGapEquals([2, 3], [3, 4], [1, 2]);
    assertGapEquals([2, 3], [4, 3], [1, 2]);
    assertGapEquals([2, 3], [3, 4], [2, 1]);
    assertGapEquals([2, 3], [4, 3], [2, 1]);
    
    assertGapEquals(empty, [1, 2], [2, 3]);
    assertGapEquals(empty, [2, 1], [2, 3]);
    assertGapEquals(empty, [1, 2], [3, 2]);
    assertGapEquals(empty, [2, 1], [3, 2]);
    assertGapEquals(empty, [3, 2], [1, 2]);
    assertGapEquals(empty, [2, 3], [1, 2]);
    assertGapEquals(empty, [3, 2], [2, 1]);
    assertGapEquals(empty, [2, 3], [2, 1]);
}

void assertGapEquals<Value>([Value, Value]|Empty expected, [Value, Value] first, [Value, Value] second)()
              given Value satisfies Comparable<Value> & Ordinal<Value>{
    assertEquals(expected, gap(first, second));
}
