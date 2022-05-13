# Example Instruction on how to send pretty HTML Emails from APEX

The instructions below outline how one can leverage a HTML email template inside Oracle APEX on ATP.

Please watch [https://youtu.be/mi1zHNkpAx8](https://youtu.be/mi1zHNkpAx8)

- Example Javascript for displaying an alert message post email send. 
```
console.log($v("P8_RETURN_ACTION"));
apex.message.alert($v("P8_RETURN_ACTION"));
```
