import ceylon.file {
    Nil,
    ExistingResource,
    current,
    File
}
import ceylon.test {
    TestListener
}
import ceylon.test.event {
    TestRunFinishEvent
}
import com.redhat.ceylon.test {
    AbstractHtmlReportGenerator
}
import java.text {
    NumberFormat
}

class HtmlReportGenerator() extends AbstractHtmlReportGenerator("test") satisfies TestListener {
    
    NumberFormat timeFormat = NumberFormat.numberInstance;
    timeFormat.groupingUsed = true;
    timeFormat.minimumFractionDigits = 3;
    timeFormat.maximumFractionDigits = 3;
    timeFormat.minimumIntegerDigits = 1;
    
    shared actual void testRunFinish(TestRunFinishEvent event) {
        generate(event.runner.description, event.result);
    }
    
    shared actual FileWriter createFile(String filePath) {
        object fileWriter satisfies FileWriter {
            File.Overwriter fw;
            
            value res = current.childPath(filePath).resource;
            switch(res)
            case(is Nil) {
                fw = res.createFile(true).Overwriter();
            }
            case(is ExistingResource) {
                fw = res.delete().createFile(true).Overwriter();
            }
            
            write(String content) => fw.write(content);
            
            close() => fw.close();
            
        }
        return fileWriter;
    }
    
    shared actual String formatTime(Integer timeInMilliseconds) {
        return timeFormat.format(timeInMilliseconds/1000.0);
    }
    
}
