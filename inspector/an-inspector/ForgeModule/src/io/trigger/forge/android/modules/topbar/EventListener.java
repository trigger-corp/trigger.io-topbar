package io.trigger.forge.android.modules.topbar;

import android.os.Bundle;

import io.trigger.forge.android.core.ForgeApp;
import io.trigger.forge.android.core.ForgeEventListener;
import io.trigger.forge.android.core.ForgeLog;
import io.trigger.forge.android.core.ForgeViewController;

public class EventListener extends ForgeEventListener {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        ForgeViewController.setNavigationBarHidden(false, null);
    }
}
