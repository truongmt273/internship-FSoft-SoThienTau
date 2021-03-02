package Pages.Call;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Call;
import com.twilio.type.PhoneNumber;
import java.net.URI;

public class Make_call_to_TwilioClient {
    public static final String ACCOUNT_SID = "ACb9879f7eb2f5bf65e2de66c457850e7f";
    public static final String AUTH_TOKEN = "281e3fa462b506735af0f6c3e12f9d05";
    public static void main(String[] args) {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
        Call call = Call.creator(
                new com.twilio.type.PhoneNumber("client:charlie"),
                new com.twilio.type.PhoneNumber("+15017122661"),
                URI.create("http://demo.twilio.com/docs/voice.xml"))
                .create();

        System.out.println(call.getSid());
    }
}
