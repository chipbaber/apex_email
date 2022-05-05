--Code to grab a html email template from github
declare
l_email_code clob;
gitLocation varchar2(2000) := 'https://github.com/chipbaber/apex_email/blob/main/sample_html_email.html';
begin
dbms_output.put_line('Getting the file from github.');
l_email_code := apex_web_service.make_rest_request( p_url => gitLocation, p_http_method => 'GET');
dbms_output.put_line('File Retrieved total length is: '||DBMS_LOB.GETLENGTH(l_email_code));
end;
