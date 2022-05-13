--Code to grab a html email template from github, then substitute in variables from APEX Page
declare
l_email_code clob;
l_email_text clob := 'Please enable HTML Email to view this content';
gitLocation varchar2(2000) := 'https://raw.githubusercontent.com/chipbaber/apex_email/main/sample_html_email.html';
email_id NUMBER;
no_email_html EXCEPTION;
PRAGMA EXCEPTION_INIT( no_email_html, -20001 );

begin
--Get the code from github
l_email_code := apex_web_service.make_rest_request( p_url => gitLocation, p_http_method => 'GET');

--Check to make sure we have the template Code if not raise a custom error
if (DBMS_LOB.GETLENGTH(l_email_code) is null or DBMS_LOB.GETLENGTH(l_email_code) < 100) THEN
 raise_application_error( -20001, 'No email sent. Unable to retrieve email template from external source.' );
end if;

--Replacement Text procedures title and text
IF (:P8_CANDIDATE_TITLE is not null) THEN
  l_email_code := replace(l_email_code,'#Add Candidate Title#',:P8_CANDIDATE_TITLE);
end if;

IF (:P8_CANDIDATE_OVERVIEW is not null) THEN
  l_email_code := replace(l_email_code,'#Add Candidate Description#',:P8_CANDIDATE_OVERVIEW);
end if;

--Build Email body to send, if checks in place
IF (:P8_TO_EMAIL is not null) THEN

  email_id := APEX_MAIL.SEND(
        p_to        => :P8_TO_EMAIL,
        p_from      => 'chipbaber@gmail.com',
        p_body      => l_email_text,
        p_body_html => l_email_code,
        p_subj      => :P8_EMAIL_SUBJECT,
        p_cc        => NULL,
        p_bcc       => NULL,
        p_replyto   => :P8_TO_REPLY_TO);

-- Check for attachment, if present attach
 IF (:P8_CANDIDATE_RESUME is not null) THEN

    FOR attachment IN (SELECT FILENAME, RESUME, MIMETYPE FROM RESUME WHERE DOC_ID IN (:P8_CANDIDATE_RESUME))
    LOOP
    APEX_MAIL.ADD_ATTACHMENT(
                p_mail_id    => email_id,
                p_attachment => attachment.RESUME,
                p_filename   => attachment.FILENAME,
                p_mime_type  => attachment.MIMETYPE);

    end LOOP;
   end if;
  -- commit to send the email
apex_mail.push_queue();
:P8_RETURN_ACTION :='Email Successfully sent';

  --do nothing
end if;

EXCEPTION
when no_email_html
then
:P8_RETURN_ACTION := sqlerrm;

end;
