function send_email(email,message)

setpref ('Internet','E_mail','omnibot317@gmail.com');
setpref ('Internet','SMTP_Server','smtp.gmail.com') ;
setpref('Internet','SMTP_Username','omnibot317'); 
setpref('Internet','SMTP_Password','un1verse') ;
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
if iscell(email)
    for ii=1:length(email)
        sendmail(email{ii},message);
    end
else
    sendmail(email,message);
end