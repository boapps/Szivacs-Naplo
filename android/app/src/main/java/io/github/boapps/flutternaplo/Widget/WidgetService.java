package io.github.boapps.flutternaplo.Widget;

import android.content.Intent;
import android.widget.RemoteViewsService;

/**
 * Created by boa on 21/10/17.
 */

public class WidgetService extends RemoteViewsService {

    @Override
    public RemoteViewsService.RemoteViewsFactory onGetViewFactory(Intent intent) {
        return (new WidgetRemoteViewsFactory(this.getApplicationContext(), intent));
    }

}