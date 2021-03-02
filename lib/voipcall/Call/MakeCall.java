package Pages.Call;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Call;
import com.twilio.type.PhoneNumber;

import java.net.URI;
import java.net.URISyntaxException;

public class MakeCall {
    // Find your Account Sid and Token at twilio.com/console
    public static final String ACCOUNT_SID = "ACb9879f7eb2f5bf65e2de66c457850e7f";
    public static final String AUTH_TOKEN = "281e3fa462b506735af0f6c3e12f9d05";
    public static void main(String[] args) throws URISyntaxException {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);

        String from = "+15017122661";
        //String from = user.phoneNo;
        String to = "+14155551212";
        //String to = list.selected;
        Call call = Call.creator(new PhoneNumber(to), new PhoneNumber(from),
                new URI("http://demo.twilio.com/docs/voice.xml")).create();
    }
}
