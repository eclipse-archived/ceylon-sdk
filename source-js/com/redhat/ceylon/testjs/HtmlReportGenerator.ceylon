import ceylon.test {
    TestListener
}
import ceylon.test.event {
    TestRunFinishEvent
}
import com.redhat.ceylon.test {
    AbstractHtmlReportGenerator
}
import ceylon.collection {
    StringBuilder
}

class HtmlReportGenerator() extends AbstractHtmlReportGenerator("test-js") satisfies TestListener {
    
    shared actual void testRunFinish(TestRunFinishEvent event) {
        generate(event.runner.description, event.result);
    }
    
    shared actual FileWriter createFile(String filePath) {
        object fileWriter satisfies FileWriter {
            
            dynamic stream;
            dynamic {
                dynamic pathApi = require("path");
                dynamic fsApi = require("fs");
                
                value pathBuilder = StringBuilder();
                value pathSegments = filePath.split((Character c) => c.string == pathApi.sep).sequence();
                for(pathSegment in pathSegments[0..pathSegments.size-2] ) {
                    pathBuilder.append(pathSegment);
                    if( !fsApi.existsSync(pathBuilder.string) ) {
                        fsApi.mkdirSync(pathBuilder.string);
                    }
                    pathBuilder.append(pathApi.sep);
                }
                assert(exists pathLastSegment = pathSegments.last);
                pathBuilder.append(pathLastSegment);
                
                stream = fsApi.createWriteStream(pathBuilder.string);
            }
            
            shared actual void write(String content) {
                dynamic {
                    stream.write(content);
                }
            }
            
            shared actual void close() {
                dynamic {
                    stream.end();
                }
            }
            
        }
        return fileWriter;
    }
    
    shared actual String formatTime(Integer timeInMilliseconds) {
        dynamic {
            dynamic t = timeInMilliseconds/1000.0;
            return t.toFixed(3);
        }
    }
    
}
