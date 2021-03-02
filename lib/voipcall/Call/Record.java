package Pages.Call;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Call;
public class Record {
    public static final String ACCOUNT_SID = "ACb9879f7eb2f5bf65e2de66c457850e7f";
    public static final String AUTH_TOKEN = "281e3fa462b506735af0f6c3e12f9d05";
    public static void main(String[] args) {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
        Call call = Call.fetcher("CA42ed11f93dc08b952027ffbc406d0868").fetch();

    }
}
