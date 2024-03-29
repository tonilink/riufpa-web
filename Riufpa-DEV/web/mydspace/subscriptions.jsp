<%--
  - subscription.jsp
  -
  - Version: $Revision: 3705 $
  -
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
  - Show a user's subscriptions and allow them to be modified
  -
  - Attributes:
  -   subscriptions  - Collection[] - collections user is subscribed to
  -   updated        - Boolean - if true, subscriptions have just been updated
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.Collection" %>

<%
    Collection[] subscriptions =
        (Collection[]) request.getAttribute("subscriptions");
    boolean updated =
        ((Boolean) request.getAttribute("updated")).booleanValue();
%>

<dspace:layout locbar="link"
               parentlink="/mydspace"
               parenttitlekey="jsp.mydspace"
               titlekey="jsp.mydspace.subscriptions.title">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css" />


<%
    if (updated)
    {
%>
	<p><strong><fmt:message key="jsp.mydspace.subscriptions.info1"/></strong></p>
<%
    }
%>
	<p><fmt:message key="jsp.mydspace.subscriptions.info2"/></p>
<%
    if (subscriptions.length > 0)
    {
%>
	<p><fmt:message key="jsp.mydspace.subscriptions.info3"/></p>

        <table class="tabela">
            <tr class="tituloTabela">
                <td colspan="2">
                    <fmt:message key="jsp.mydspace.subscriptions.title"/>
                </td>
            </tr>
            <tr>
                <th>
                    <fmt:message key="jsp.mydspace.subscriptions.collection"/>
                </th>
                <th>
                    <fmt:message key="jsp.mydspace.subscriptions.action"/>
                </th>
            </tr>
<%
        for (int i = 0; i < subscriptions.length; i++)
        {
            if(i % 2 == 0){
%>
            <tr class="stripe">
                <%
                               } else{
                %>
            <tr>
                <%
                               }
            %>
                 <td>
                      <a href="<%= request.getContextPath() %>/handle/<%= subscriptions[i].getHandle() %>"><%= subscriptions[i].getMetadata("name") %></a>
                 </td>
                 <td>
                    <form method="post" action="">
                        <input type="hidden" name="collection" value="<%= subscriptions[i].getID() %>" />
			<input type="submit" class="button" name="submit_unsubscribe" value="<fmt:message key="jsp.mydspace.subscriptions.unsub.button"/>" />
                    </form>
                 </td>
            </tr>
<%
        }
%>
        </table>

    <br/>

    <center>
        <form method="post" action="">
    	    <input type="submit" class="buttonRed" name="submit_clear" value="<fmt:message key="jsp.mydspace.subscriptions.remove.button"/>" />
        </form>
    </center>
<%
    }
    else
    {
%>
	<p><fmt:message key="jsp.mydspace.subscriptions.info4"/></p>
<%
    }
%>

</dspace:layout>
