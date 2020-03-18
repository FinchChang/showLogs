<%@ page language="java" contentType="text/html; charset=UTF-8"
    import  =   "java.io.*"
    import  =   "java.util.Map"
    import  =   "org.json.simple.JSONArray"
    import  =   "org.json.simple.JSONObject"
    import  =   "java.io.File"
    pageEncoding="UTF-8"%><%
    try{
            String inputDataLength = request.getParameter("dataLength");
            String inputDataLine = request.getParameter("dataCounter");
            if(inputDataLength != null){
                String FileName = "logexample.txt";
                File file = new File(FileName);
                if(file.exists()){
                    long FileLength=file.length();
                    JSONObject json = new JSONObject();
                    if( Long.parseLong(inputDataLength) < FileLength){
                        String content = "";
                        String PrintResult="";
                        FileInputStream fis = null;
                        BufferedInputStream bis = null;
                        DataInputStream dis = null;
                        fis = new FileInputStream(file);
                        bis = new BufferedInputStream(fis);
                        dis = new DataInputStream(bis);
                        int counter=0;
                        int LastCount = Integer.parseInt(inputDataLine);
                        while (dis.available() != 0) {
                            counter++;
                            content = dis.readLine();
                            if(LastCount!=0 && counter <= LastCount){
                                continue;
                            }
                            content = content.replace("<","&lt;");
                            content = content.replace(">","&gt;");
   
                            content = new String(content.getBytes("8859_1"),"UTF-8");

                            content = content+"<br>";
                            PrintResult += content;
                            if(counter > (LastCount+3000)){
                                FileLength = 1;
                                break;
                            }
                        }
                        fis.close();
                        bis.close();
                        dis.close();

                        json.put("size", FileLength);
                        json.put("line", counter);
                        json.put("content", PrintResult);
                        if(LastCount!=0){
                            response.setStatus(206);
                        }
                        out.print(json.toString());

                    }else{
                        response.sendError(204, "No content update" );
                    }
                }
            }
            else{
            System.out.println("inputDataLength is null");
            }

       }catch(Exception e){
           System.out.println(e);
       }
       %>
