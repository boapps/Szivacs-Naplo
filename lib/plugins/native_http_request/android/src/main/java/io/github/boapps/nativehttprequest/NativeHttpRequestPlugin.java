
package io.github.boapps.nativehttprequest;

import android.app.Activity;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import android.os.StrictMode;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** NativeHttpRequestPlugin */
public class NativeHttpRequestPlugin implements MethodCallHandler {
    /** Plugin registration. */
    static Activity activity;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "native_http_request");
        channel.setMethodCallHandler(new NativeHttpRequestPlugin());
        activity = registrar.activity();
    }

    private String getResponse = "";
    private String url = "";
    private String data = "";
    private HashMap<String, String> headers = new HashMap<>();

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        headers = call.argument("headers");
        url = call.argument("url").toString();
        data = call.argument("data");
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();

        StrictMode.setThreadPolicy(policy);

        if (call.method.equals("getRequest")) {
            Thread thread = new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        URL treqURL = new URL(url);
                        HttpURLConnection trequest = (HttpURLConnection) (treqURL.openConnection());
                        for (Map.Entry<String, String> entry : headers.entrySet()) {
                            trequest.addRequestProperty(entry.getKey(), entry.getValue());
                        }
                        trequest.setRequestMethod("GET");
                        trequest.connect();
                        getResponse = readStream(trequest.getInputStream());
                        trequest.disconnect();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    result.success(getResponse);
                }
            });
            thread.setPriority(Thread.MIN_PRIORITY);
            thread.run();
            //thread.start();

        } else if (call.method.equals("postRequest")){
            new Thread(new Runnable() {
                public void run() {
                    try {
                        URL treqURL = new URL(url);
                        HttpURLConnection trequest = (HttpURLConnection) (treqURL.openConnection());
                        trequest.setDoOutput(true);
                        for (Map.Entry<String, String> entry : headers.entrySet()) {
                            trequest.addRequestProperty(entry.getKey(), entry.getValue());
                        }
                        trequest.setRequestMethod("POST");
                        trequest.connect();
                        OutputStreamWriter writer = new OutputStreamWriter(trequest.getOutputStream());
                        writer.write(data);
                        writer.flush();
                        getResponse = readStream(trequest.getInputStream());
                        trequest.disconnect();
                        result.success(getResponse);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }).start();

        } else {
            result.notImplemented();
        }
    }

    private static String readStream(InputStream is) throws IOException {
        final BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
        StringBuilder total = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            total.append(line);
        }
        return total.toString();
    }

}