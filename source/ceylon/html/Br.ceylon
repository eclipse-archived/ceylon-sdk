"
 The __&lt;br&gt;__ element produces a line break in text (carriage-return). 
 It is useful for writing a poem or an address, where the division of lines is significant.
 
 Example:
 
  <table style='width:100%'>
     <tr style='vertical-align: top'>
         <td style='border-style:none'>
         
 <pre data-language='ceylon'>
 P {
     \"John Doe\", Br(),
     \"Acme Corporation\", Br()
 };
 </pre>
 
         </td>
         <td style='border-style:none'>
         
 <pre data-language='html'>
 &lt;p&gt;
     John Doe&lt;br&gt;
     Acme Corporation&lt;br&gt;
 &lt;/p&gt;
 </pre>
         </td>         
     </tr>
 </table>
 
 Technical details about this element can be found on the
 [Official W3C reference](https://www.w3.org/TR/html5/text-level-semantics.html#the-br-element).
"
tagged("flow", "phrasing")
shared class Br() 
        extends Element("br") 
        satisfies FlowCategory & PhrasingCategory {
    "This element has no children."
    shared actual [] children = [];
}