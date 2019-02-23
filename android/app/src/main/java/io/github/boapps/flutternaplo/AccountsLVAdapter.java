package io.github.boapps.flutternaplo;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by boa on 24/09/17.
 */

public class AccountsLVAdapter extends BaseAdapter {
    LayoutInflater inflator = null;
    Context context;
    private ArrayList<String> accounts;
    private ArrayList<Integer> ids;

    public AccountsLVAdapter(ArrayList<String> accounts, ArrayList<Integer> ids, Context con) {
        this.accounts = accounts;
        this.ids = ids;
        context = con;
    }

    @Override
    public int getCount() {
        return accounts.size();
    }

    @Override
    public Object getItem(int i) {
        return accounts.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(final int i, View view, ViewGroup viewGroup) {
        if (view == null) {
            inflator = (LayoutInflater) context.getSystemService(
                    Activity.LAYOUT_INFLATER_SERVICE);
            view = inflator.inflate(R.layout.account_lv_item, null);
        }

        TextView accountNameTv = view.findViewById(R.id.account_name_tv);
        accountNameTv.setText(accounts.get(i) + " (" + ids.get(i) + ")");

        return view;
    }
}
