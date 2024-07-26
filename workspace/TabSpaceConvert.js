function onProcess()
{
  var input = document.getElementById("input").value;
  
  if (!input)
  {
    // Null or undefined or bad input
    alert("Invalid input");
  }
  
  var output = "";
  
  // Replace line-breaks with "\n"
  output = input.replace(/(?:\r\n|\r|\n)/g, '\\n');
  output2 = output.replace(/\t/g, '\\t');
  output3 = output2.replace(/    /g, '\\t');
  
  document.getElementById("output").value = output3;
}