package com.andrewackerman.microphonestream;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.io.File;

/** MicrophoneStreamPlugin */
public class MicrophoneStreamPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener, MicrophoneStreamHandler {
    private static final String TAG = "MicrophoneStreamPlugin";
    private static final String PERM_MANIFEST = Manifest.permission.RECORD_AUDIO;

    private MethodChannel channel;
    private Registrar registrar;

    private Result permissionsGetResult = null;

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "microphone_stream");
        final MicrophoneStreamPlugin plugin = new MicrophoneStreamPlugin(registrar, channel);

        channel.setMethodCallHandler(plugin);
        registrar.addRequestPermissionsResultListener(plugin);
    }

    public MicrophoneStreamPlugin(Registrar registrar, MethodChannel channel) {
        this.registrar = registrar;
        this.channel = channel;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {

            // Utility Functions

            case "buildFilePath":
                result.success(buildFilePath(call.arguments.toString()));
                break;

            // Stream Functions

            case "checkPermissions":
                result.success(checkPermissions());
                break;

            case "requestPermissions":
                requestPermissions();
                permissionsGetResult = result;
                break;

            case "startListening":
                startListening();
                break;

            case "stopListening":
                stopListening();
                break;

            // Default Handling

            default:
                result.notImplemented();
                break;
        }
    }

    //{ region Permissions

    private boolean checkPermissions() {
        Activity activity = registrar.activity();
        int status = ContextCompat.checkSelfPermission(activity, PERM_MANIFEST);

        return status == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        Activity activity = registrar.activity();
        ActivityCompat.requestPermissions(activity, new String[] { PERM_MANIFEST }, 0);
        Log.d(TAG, "permissions requested");
    }

    //} endregion

    //{ region Utility Handlers

    private String buildFilePath(String filename) {
        Activity activity = registrar.activity();
        String path = activity.getFilesDir().getAbsolutePath();
        String[] pathSegments = filename.split("/");
        String file = pathSegments[pathSegments.length-1];

        for (int i = 0; i < pathSegments.length-1; i++) {
            path += "/" + pathSegments[i];
        }

        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdir();
        }

        return path + "/" + file;
    }

    //} endregion

    //{ Microphone Handlers

    private void startListening() {
        MicrophoneStream.instance.prepare();
        MicrophoneStream.instance.setHandler(this);
        MicrophoneStream.instance.start();
    }

    private void stopListening() {
        MicrophoneStream.instance.stop();
    }

    public void processSampleData(short[] data) {
        byte[] bytes = new byte[data.length * 2];

        for (int i = 0; i < data.length; i++) {
            bytes[i*2] = (byte) (data[i] & 0x00FF);
            bytes[i*2 + 1] = (byte) ((data[i] & 0xFF00) >> 8);
        }

        this.channel.invokeMethod("handleSamples", bytes);
    }

    //}

    //{ region RequestPermissionsResultListener

    @Override
    public boolean onRequestPermissionsResult(int code, String[] perms, int[] results) {
        int status = -1;
        String permission = perms[0];

        Log.d(TAG, "callback entered");
        Log.d(TAG, "permission: '" + permission + "'");
        Log.d(TAG, "manifest: '" + permission + "'");

        if (!permission.equals(PERM_MANIFEST)) {
            Log.d(TAG, "permission doesn't match manifest, passing along to another handler");
            return false;
        }

        if (code == 0 && results.length > 0) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(registrar.activity(), permission)) {
                status = 0;
            } else {
                int checkStatus = ActivityCompat.checkSelfPermission(registrar.context(), permission);
                if (checkStatus == PackageManager.PERMISSION_GRANTED) {
                    status = 1;
                } else {
                    Log.e(TAG, "Permission status was not granted: " + checkStatus);
                    status = 0;
                }
            }
        }

        Log.d(TAG, "status: " + status);
        Log.d(TAG, "resultExists: " + (permissionsGetResult != null));

        if (permissionsGetResult != null) {
            permissionsGetResult.success(status == 1);
        }

        return status == 1;
    }

    //} endregion
}
