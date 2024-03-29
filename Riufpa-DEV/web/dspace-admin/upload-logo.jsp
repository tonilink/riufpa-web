<%--
  - Version: $Revision: 3705 $
  - Date: $Date: 2009-04-11 17:02:24 +0000 (Sat, 11 Apr 2009) $
  -
  - Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
  - Institute of Technology.  All rights reserved.
  -
  - Redistribution and use in source and binary forms, with or without
  - modification, are permitted provided that the following conditions are
  - met:
  -
  - - Redistributions of source code must retain the above copyright
  - notice, this list of conditions and the following disclaimer.
  -
  - - Redistributions in binary form must reproduce the above copyright
  - notice, this list of conditions and the following disclaimer in the
  - documentation and/or other materials provided with the distribution.
  -
  - - Neither the name of the Hewlett-Packard Company nor the name of the
  - Massachusetts Institute of Technology nor the names of their
  - contributors may be used to endorse or promote products derived from
  - this software without specific prior written permission.
  -
  - THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  - ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  - LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  - A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  - HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  - INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  - BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  - OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  - ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  - TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  - USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  - DAMAGE.
--%>

<%--
  - Form to upload a logo
  -
  - Attributes:
  -    community    - community to upload logo for
  -    collection   - collection to upload logo for - "overrides" community
  -                   if this isn't null
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.Collection" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    Collection collection = (Collection) request.getAttribute("collection");
    Community community = (Community) request.getAttribute("community");

%>

<dspace:layout titlekey="jsp.dspace-admin.upload-logo.title"
               navbar="admin"
               locbar="link"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/edit-col-com.css" type="text/css"/>


    <div class="fundo">
        <table class="metadados">
            <tr>
                <th colspan="2">
                    <fmt:message key="jsp.dspace-admin.upload-logo.title"/>
                </th>
            </tr>

            <tr>
                <td>
                    <div style="text-align: center;">
                        <%
                            if (collection != null) {
                        %>
                        <fmt:message key="jsp.dspace-admin.upload-logo.select.col">
                            <fmt:param><%= collection.getMetadata("name")%></fmt:param>
                        </fmt:message>
                        <%
                        } else {
                        %>
                        <fmt:message key="jsp.dspace-admin.upload-logo.select.com">
                            <fmt:param><%= community.getMetadata("name")%></fmt:param>
                        </fmt:message>
                        <%
                            }
                        %>
                    </div>
                </td>
            </tr>

            <tr>
                <td>
                    <form method="post" enctype="multipart/form-data" action="" onsubmit="return validar();">
                        <input type="file" id="arquivo" size="40" name="file"/>

                        <input type="hidden" name="community_id" value="<%= community.getID()%>" />

                        <%  if (collection != null) {%>
                        <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
                        <%  }%>

                        <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.dspace-admin.general.upload"/>" />
                    </form>
                </td>
            </tr>

        </table>
    </div>

    <script type="text/javascript">
        function validar(){
            if($('arquivo').value === ""){
                return false;
            } else{
                return true;
            }
        }
    </script>
</dspace:layout>
