<%--
  - verify-prune.jsp
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
  - Verify that it's OK to "prune" the item after changing the answer to a
  - question on the first page
  -
  - Attributes to pass in:
  -    multiple.titles, published.before, multiple.files - Booleans, indicating
  -                      the user's choices on the initial questions page
  -    will.remove.titles, will.remove.date, will.remove.files - Booleans,
  -                      indicating consequences of new answers to questions
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);

    //get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

    boolean multipleTitles = ((Boolean) request.getAttribute("multiple.titles")).booleanValue();
    boolean publishedBefore = ((Boolean) request.getAttribute("published.before")).booleanValue();
    boolean multipleFiles = ((Boolean) request.getAttribute("multiple.files")).booleanValue();

    boolean willRemoveTitles = ((Boolean) request.getAttribute("will.remove.titles")).booleanValue();
    boolean willRemoveDate = ((Boolean) request.getAttribute("will.remove.date")).booleanValue();
    boolean willRemoveFiles = ((Boolean) request.getAttribute("will.remove.files")).booleanValue();

    String buttonPressed = (String) request.getAttribute("button.pressed");

    request.setAttribute("LanguageSwitch", "hide");
%>

<dspace:layout locbar="off"
               navbar="off"
               titlekey="jsp.submit.verify-prune.title"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>

    <div class="formularioDesc">
        <h3><fmt:message key="jsp.submit.verify-prune.heading"/></h3>

        <%-- <p><strong>The changes you've made to the first "Describe Your Item" page
        will affect your submission:</strong></p> --%>
        <p><strong><fmt:message key="jsp.submit.verify-prune.info1"/></strong></p>

        <%
            if (willRemoveTitles) {
        %>
        <%-- <p>You've indicated that your submission does not have alternative titles,
        but you've already entered some.  If you proceed with this change, the
        alternative titles you've entered will be removed.</p> --%>
        <p><fmt:message key="jsp.submit.verify-prune.info2"/></p>
        <%    }

            if (willRemoveDate) {
        %>
        <%-- <p>You've indicated that your submission has not been published or publicly
        distributed before, but you've already entered an issue date, publisher
        and/or citation.  If you proceed, this information will be removed, and
        DSpace will assign an issue date.</p> --%>
        <p><fmt:message key="jsp.submit.verify-prune.info3"/></p>
        <%    }

            if (willRemoveFiles) {
        %>
        <%-- <p>You've indicated that the item you're submitting consists of only a single
        file, but you've already uploaded more than one file.  If you proceed, only
        the first file you uploaded will be kept, and the rest will be discarded by
        the system. (The files on your local hard drive will not be affected.)</p> --%>
        <p><fmt:message key="jsp.submit.verify-prune.info4"/></p>
        <%    }
        %>

        <%-- <p><strong>Are you sure you want to proceed with the changes?</strong></p> --%>
        <p class="centralizar">
            <fmt:message key="jsp.submit.verify-prune.question"/>
        </p>


        <form action="<%= request.getContextPath()%>/submit" method="post" onkeydown="return disableEnterKey(event);">

            <%-- Embed necessary information --%>
            <input type="hidden" name="multiple_titles" value="<%= multipleTitles%>"/>
            <input type="hidden" name="published_before" value="<%= publishedBefore%>"/>
            <input type="hidden" name="multiple_files" value="<%= multipleFiles%>"/>
            <input type="hidden" name="will_remove_titles" value="<%= willRemoveTitles%>"/>
            <input type="hidden" name="will_remove_date" value="<%= willRemoveDate%>"/>
            <input type="hidden" name="will_remove_files" value="<%= willRemoveFiles%>"/>

            <%-- Pass through original button press --%>
            <input type="hidden" name="<%= buttonPressed%>" value="true"/>

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request)%>

            <%-- Note: These submit buttons' names don't start with "submit", so the
              -- Previously passed in button will be picked up --%>
            <div class="centralizar">
                <input type="submit" name="prune" class="button" value="<fmt:message key="jsp.submit.verify-prune.proceed.button"/>" />
                <input type="submit" name="do_not_prune" class="button" value="<fmt:message key="jsp.submit.verify-prune.notproceed.button"/>" />
            </div>
            <br /><br />

        </form>

    </div>
</dspace:layout>
