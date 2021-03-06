<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

    <HEAD>
        <TITLE>Reading Logs</TITLE>
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
<script>
    var GetLogPath="GetLogInfo.jsp";
    var timeout = 0;
    var FileSize = 0;
    var nowSize = -1;
    var nowCounter = 0;
     //bar move to bottom
     function MoveToBottom(){
         $("html, body").animate({ scrollTop: $(document).height() }, 1000);
     }
    //Get File content
    function getFileContent(){
        $.ajax({type: "POST", 
                url: GetLogPath, 
                async: false,
                data:{option:nowCounter} ,
                success: function(result){
                 var JSONtmp = JSON.parse(result);
                 FileSize = JSONtmp.size;
                 nowCounter = JSONtmp.line;
                 $("#log").append(JSONtmp.content);
                 MoveToBottom();
          }});
    }
</script>
    </HEAD>
        <body>

        <div id="log">資料讀取中...<br></div>
     <br>
 <%
        String clock = request.getParameter( "clock" );
        if( clock == null ) {
        %>
        <script>getFileContent();</script>
        <%
        clock = "5";
    }
%>
    <style type="text/css">
        span.bold-red {
        color: red;
        font-weight: bold;
        }
        span.otp-msg {
        color:  #02c874;
        font-weight: bold;
        }
    </style>


     <form action="<%=request.getRequestURL()%>" name="forma">
        Seconds remaining: <input type="text" name="clock" value="<%=clock%>" style="border:0px solid white">
    </form>
     </body>
    <script>
    $(document).ready(function(){
        MoveToBottom();
     });
    //Get File size
    function getFileInfo(){
        $.ajax({type: "POST", url: GetLogPath , data:{option:"length"} ,success: function(result){
               var JSONSizeTmp = JSON.parse(result);
               nowSize=JSONSizeTmp.size; 
          }});
    }
    function timer(){
        if( --timeout > 0 ){
            document.forma.clock.value = timeout;
            window.setTimeout( "timer()", 1000 );
        }
        else
        {
            getFileInfo();
            if(FileSize != nowSize){
                getFileContent();
            }
                timeout = 5;
                timer();
        }
    }
    timer(); // call timer() after page is loaded 
    </script>



</HTML>
