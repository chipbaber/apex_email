--Code to grab a html email template from github
declare
l_email_code clob;
gitLocation varchar2(2000) := 'https://raw.githubusercontent.com/chipbaber/apex_email/main/sample_html_email.html';
amt INTEGER := 8000; -- max bytes to pull per CLOB in APEX
pos INTEGER := 1;
buf VARCHAR2(32767); -- max buffer size per CLOB pull in APEX
len INTEGER;

begin
dbms_output.put_line('Getting the file from github.');
--Get the code from github
l_email_code := apex_web_service.make_rest_request( p_url => gitLocation, p_http_method => 'GET');
dbms_output.put_line('File Retrieved total length is: '||DBMS_LOB.GETLENGTH(l_email_code));

--Check for zero length Clob
IF (DBMS_LOB.GETLENGTH(l_email_code) = 0) THEN
    HTP.P('Document pulled from github is zero length.');
  ELSE
    len := DBMS_LOB.GETLENGTH(l_email_code);
        /* iterate through the length of the clob*/
        WHILE pos < len
        loop
        begin
        dbms_lob.read(l_email_code, amt, pos, buf);
        pos := pos + amt;

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
