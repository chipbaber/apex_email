--Code to grab a html email template from github, then substitute in variables from APEX Page
declare
l_email_code clob;
gitLocation varchar2(2000) := 'https://raw.githubusercontent.com/chipbaber/apex_email/main/sample_html_email.html';
amt INTEGER := 8000; -- max bytes to pull per CLOB in APEX
pos INTEGER := 1;
buf VARCHAR2(32767); -- max buffer size per CLOB pull in APEX
len INTEGER;
title VARCHAR2(50) := :P8_CANDIDATE_TITLE;
candidtate_description VARCHAR2(400) := :P8_CANDIDATE_OVERVIEW;

begin

--Get the code from github
l_email_code := apex_web_service.make_rest_request( p_url => gitLocation, p_http_method => 'GET');

--Comment this out if needed
htp.p('<b>To:  </b>'||:P8_TO_EMAIL||'<br>');
htp.p('<b>Reply To:  </b>'||:P8_TO_REPLY_TO||'<br>');
htp.p('<b>Email Subject:  </b>'||:P8_EMAIL_SUBJECT||'<br>');



/*Check for zero length Clob*/
IF (DBMS_LOB.GETLENGTH(l_email_code) = 0) THEN
    HTP.P('Document pulled from github is zero length.');
  ELSE
    len := DBMS_LOB.GETLENGTH(l_email_code);
        -- iterate through the length of the clob
        WHILE pos < len
        loop
        begin
        dbms_lob.read(l_email_code, amt, pos, buf);
        pos := pos + amt;

        --Replacement Text procedures title and text
        IF (title is not null) THEN
          buf := replace(buf,'#Add Candidate Title#',title);
        end if;
        IF (candidtate_description is not null) THEN
        buf := replace(buf,'#Add Candidate Description#',candidtate_description);
        end if;

        -- print to APEX
        htp.p(buf);

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
             l_email_code := EMPTY_CLOB();
         END;

        end loop;
end if;


EXCEPTION
    WHEN NO_DATA_FOUND THEN
      l_email_code := EMPTY_CLOB();
end;
