import ceylon.test { ... }

import ceylon.regex { ... }
import ceylon.test.engine {
    DefaultLoggingListener
}

shared void run() {
    createTestRunner([`module test.ceylon.regex`], [DefaultLoggingListener()]).run();
}

String input = "De aap is uit de (mouw): het was een broodje aap! Ben ik mooi in de aap gelogeerd!";
String expected1 = "MatchResult[3-6 'aap' []]";
String expected2 = "[MatchResult[3-6 'aap' []], MatchResult[45-48 'aap' []], MatchResult[68-71 'aap' []]]";
String expected3 = "[MatchResult[3-6 'aap' [aap]], MatchResult[45-48 'aap' [aap]], MatchResult[68-71 'aap' [aap]]]";
String expected4 = "[MatchResult[0-9 'De aap is' [De, is]], MatchResult[65-81 'de aap gelogeerd' [de, gelogeerd]]]";

test
shared void testCreateNoFlags() {
    value re = regex("");
    assertFalse(re.global);
    assertFalse(re.ignoreCase);
    assertFalse(re.multiLine);
}

test
shared void testCreateWithFlags() {
    value re = regex{expression=""; global=true; ignoreCase=true; multiLine=true;};
    assertTrue(re.global);
    assertTrue(re.ignoreCase);
    assertTrue(re.multiLine);
}

test
shared void testCreatePatternError() {
    try {
        regex("\\");
        assertFalse(true, "We shouldn't be here");
    } catch (Exception ex) {
        assertThatException(ex).hasType(`RegexException`);
        assertThatException(ex).hasMessage("Problem found within regular expression");
    }
}

test
shared void testFind() {
    value result = regex{expression="a+p"; global=true;}.find(input);
    print(result);
    assertEquals(result?.string, expected1);
}

test
shared void testFindGlobal() {
    value result = regex{expression="a+p"; global=true;}.find(input);
    print(result);
    assertEquals(result?.string, expected1);
}

test
shared void testFindIgnoreCase() {
    value result = regex{expression="AAP"; ignoreCase=true;}.find(input);
    print(result);
    assertEquals(result?.string, expected1);
}

test
shared void testFindAll() {
    value result = regex("a+p").findAll(input);
    print(result);
    assertEquals(result.string, expected2);
}

test
shared void testFindAllGlobal() {
    value result = regex{expression="a+p"; global=true;}.findAll(input);
    print(result);
    assertEquals(result.string, expected2);
}

test
shared void testFindAllGroup() {
    value result = regex("(a+p)").findAll(input);
    print(result);
    assertEquals(result.string, expected3);
}

test
shared void testFindAllGroups() {
    value result = regex("""(\w+)\saap\s(\w+)""").findAll(input);
    print(result);
    assertEquals(result.string, expected4);
}

test
shared void testNotFound() {
    value result = regex("burritos").find(input);
    assertNull(result);
}

test
shared void testQuote() {
    value q = quote("""$.*[]^\""");
    assertEquals(q, """\$\.\*\[\]\^\\""");
}

test
shared void testQuote2() {
    value q = quote("""\E\Q\E""");
    print(q);
    assertEquals(q, """\\E\\Q\\E""");
}

test
shared void testReplace() {
    value result = regex("aap").replace(input, "noot");
    print(result);
    assertEquals(result, "De noot is uit de (mouw): het was een broodje aap! Ben ik mooi in de aap gelogeerd!");
    value result2 = regex("[0-9]+ years").replace("90 years old", "very");
    print(result2);
    assertEquals(result2, "very old");
}

test
shared void testReplaceGlobal() {
    value result = regex{expression="aap"; global=true;}.replace(input, "noot");
    print(result);
    assertEquals(result, "De noot is uit de (mouw): het was een broodje noot! Ben ik mooi in de noot gelogeerd!");
}

test native
shared void testReplaceError();

test native("jvm")
shared void testReplaceError() {
    try {
        regex("aap").replace(input, "$'");
        assertFalse(true, "We shouldn't be here");
    } catch (Exception ex) {
        assertThatException(ex).hasType(`RegexException`);
        assertThatException(ex).hasMessage("$\` and $' replacements are not supported");
    }
}

test native("js")
shared void testReplaceError() {
}

test
shared void testReplaceFunctionString() {
    value result = regex{expression="aap"; global=true;}.replace(input, String.reversed);
    print(result);
    assertEquals(result, "De paa is uit de (mouw): het was een broodje paa! Ben ik mooi in de paa gelogeerd!");
}

test
shared void testReplaceFunctionMatchResult() {
    function swapGroups(MatchResult match) {
        assert (exists firstGroup = match.groups[0], exists secondGroup = match.groups[1]);
        
        return secondGroup + firstGroup;
    }
    value result = regex{expression="(oo)(\\w+)"; global=true;}.replace(input, swapGroups);
    print(result);
    assertEquals(result, "De aap is uit de (mouw): het was een brdjeoo aap! Ben ik mioo in de aap gelogeerd!");
}

test
shared void testSplit() {
    value result = regex{expression=" "; global=true;}.split(input);
    print(result);
    assertEquals(result, ["De", "aap", "is", "uit", "de", "(mouw):", "het", "was", "een", "broodje", "aap!", "Ben", "ik", "mooi", "in", "de", "aap", "gelogeerd!"]);
}

test
shared void testSplitWithLimit() {
    value result = regex{expression=" "; global=true;}.split(input,3);
    print(result);
    assertEquals(result, ["De", "aap", "is"]);
}

test
shared void testTest() {
    assertTrue(regex("a+p").test(input));
    assertTrue(regex{expression="^de.*RD!$"; ignoreCase=true;}.test(input));
    assertTrue(regex("[0-9]+ years").test("90 years old"));
}

test
shared void testTestQuoted() {
    assertFalse(regex(" (mouw): ").test(input));
    print(quote(" (mouw): "));
    assertTrue(regex(quote(" (mouw): ")).test(input));
}

test
shared void testTestUnusedGroup() {
    // See issue ceylon/ceylon-sdk#586
    value result = regex("^('.*')$|^(\".*\")$").findAll("'title'");
    print(result);
    assertEquals(result.string, "[MatchResult[0-7 ''title'' ['title', <null>]]]");
}

shared void runAll() {
    testCreateNoFlags();
    testCreateWithFlags();
    testCreatePatternError();
    testFind();
    testFindGlobal();
    testFindIgnoreCase();
    testFindAll();
    testFindAllGlobal();
    testFindAllGroup();
    testFindAllGroups();
    testNotFound();
    testQuote();
    testQuote2();
    testReplace();
    testReplaceGlobal();
    testReplaceError();
    testReplaceFunctionString();
    testReplaceFunctionMatchResult();
    testSplit();
    testSplitWithLimit();
    testTest();
    testTestQuoted();
    testTestUnusedGroup();
}
