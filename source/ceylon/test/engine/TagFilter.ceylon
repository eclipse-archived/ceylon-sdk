import ceylon.test {
    TestDescription
}
import ceylon.collection {
    ArrayList
}
import ceylon.test.annotation {
    TagAnnotation
}

import ceylon.test.engine.internal {
    findAnnotations
}

"A [[ceylon.test::TestFilter]] which filter tests by [[tags|ceylon.test::tag]]."
shared class TagFilter({String*} filters) {
    
    "Returns true if the given test satisfy filter."
    shared Boolean filterTest(TestDescription description) {
        value foundTags = findTestTags(description);
        return filterTestTags(foundTags);
    }
    
    "Returns true if the given tags satisfy filter."
    shared Boolean filterTestTags({String*} testTags) {
        variable Integer includeTags = 0;
        variable Integer excludeTags = 0;
        variable Integer includeVote = 0;
        variable Integer excludeVote = 0;
        
        for (filter in filters) {
            if (filter.startsWith("!")) {
                excludeTags++;
                if (testTags.contains(filter.spanFrom(1))) {
                    excludeVote++;
                }
            } else {
                includeTags++;
                if (testTags.contains(filter)) {
                    includeVote++;
                }
            }
        }
        
        if( excludeVote>0 ) {
            return false;
        }
        if( includeTags>0 && includeVote == 0 ) {
            return false;
        }
        
        return true;
    }
    
    {String*} findTestTags(TestDescription description) {
        value testTags = ArrayList<String>();
        if (exists f = description.functionDeclaration) {
            TagAnnotation[] tagAnnotations = findAnnotations<TagAnnotation>(f, description.classDeclaration);
            for (tagAnnotation in tagAnnotations) {
                testTags.addAll(tagAnnotation.tags);
            }
        }
        return testTags;
    }
    
}
