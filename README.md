# Example Instruction on how to send pretty HTML Emails from APEX

The instructions below outline how one can leverage a HTML email template inside Oracle APEX on ATP. The content is best explained through video.

Please watch [https://youtu.be/mi1zHNkpAx8](https://youtu.be/mi1zHNkpAx8) to see step 1. How to pull html and embed inside Oracle APEX.

To learn how to preview and send emails with attachments from APEX please view [https://youtu.be/B3BzqX9WPH0](https://youtu.be/B3BzqX9WPH0)

- Example Javascript for displaying an alert message post email send.
```
console.log($v("P8_RETURN_ACTION"));
apex.message.alert($v("P8_RETURN_ACTION"));
```
