<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SMSNotificationModel;
use App\Models\TimeInVisitorLogApiModel;
use App\Services\SMSApiService;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TimeOutVisitorLogApiController extends Controller
{
    public function verifyCheckOut(Request $request)
    {


        # Validating request

        $validator = Validator::make($request->all(), [
            'settings.branchId' => 'required',
            'settings.eventId' => 'required',
            'settings.location' => 'required',
            'settings.countryCode' => 'required | numeric',
            'visitor.customerId' => 'required | numeric',
        ]);

        # Validating request

        if ($validator->fails()) {
            return response()->json([
                'code' => '422',
                'message' => 'Validation Error(s)',
                'data' => $validator->errors()
            ], 200);
        }

        $settings = (object) $request->settings;
        $visitor = (object) $request->visitor;



        # Forming visitor number
        $destination = trim($settings->countryCode) . trim($visitor->customerId);

        // return $request->company_name . " -  " . $destination;

        try {
            # Generate token
            $token = (string) mt_rand(1000, 9999);

            // $sms_message = "Check-out token: $token";

            # Use SMS Service
            // $sMSApiService = new SMSApiService();
            // $sms = $sMSApiService->call_sms_api($request->company_name, $destination, $sms_message);

            $customer = TimeInVisitorLogApiModel::where('customer_id', trim($visitor->customerId))->whereDate('created_at', Carbon::today())->first();

            if (!is_null($customer)) {

                return response()->json([
                    'code' => '000',
                    'message' => "You are about to check out",
                    'data' => $customer
                ], 200);
            } else {
                return response()->json([
                    'code' => '500',
                    'message' => "Sorry, You have not check in today",
                    'data' => NULL
                ], 200);
            }
        } catch (\Exception $e) {
            return response()->json([
                'code' => '500',
                'message' => $e->getMessage(),
                'data' => NULL
            ], 200);
        }
    }

    public function checkOut(Request $request)
    {


        # Validating request

        $validator = Validator::make($request->all(), [
            'settings.branchId' => 'required',
            'settings.eventId' => 'required',
            'settings.location' => 'required',
            'settings.countryCode' => 'required | numeric',
            'visitor.customerId' => 'required | numeric',
            'visitor.visitor_log_uuid' => 'required',
        ]);

        # Validating request

        if ($validator->fails()) {
            return response()->json([
                'code' => '422',
                'message' => 'Validation Error(s)',
                'data' => $validator->errors()
            ], 200);
        }

        $settings = (object) $request->settings;
        $visitor = (object) $request->visitor;



        # Forming visitor number
        $destination = trim($settings->countryCode) . trim($visitor->customerId);

        // return $request->company_name . " -  " . $destination;

        try {
            # Generate token
            $token = (string) mt_rand(1000, 9999);

            // $sms_message = "Check-out token: $token";

            # Use SMS Service
            // $sMSApiService = new SMSApiService();
            // $sms = $sMSApiService->call_sms_api($request->company_name, $destination, $sms_message);

            $customer = TimeInVisitorLogApiModel::where('customer_id', trim($visitor->customerId))->where('uuid', $visitor->visitor_log_uuid)->first();

            if (!is_null($customer)) {
                $sms_message = "Bye, See you again; $customer->fullName";


                # Update check out for visitor in the visitor log table
                $customer->is_out = "YES";
                $customer->time_out = NOW();
                $customer->save();



                # Use SMS Service
                $sMSApiService = new SMSApiService();
                $sms = $sMSApiService->call_sms_api($request->company_name, $destination, $sms_message);

                if ($sms->ok()) {
                    # Insert check sms into sms table
                    $sMSNotificationModel = new SMSNotificationModel();
                    $sMSNotificationModel->company_id = $customer->company_id;
                    $sMSNotificationModel->branch_id = $customer->branch_id;
                    $sMSNotificationModel->event_id = $customer->event_id;
                    $sMSNotificationModel->country_phone_code = $customer->country_phone_code;
                    $sMSNotificationModel->customer_id = $visitor->customerId;
                    $sMSNotificationModel->message = $sms_message;
                    $sMSNotificationModel->type = "OUT";

                    $sMSNotificationModel->save();
                }


                return response()->json([
                    'code' => '000',
                    'message' => "Bye, See you again; $customer->fullName",
                    'data' => NULL
                ], 200);
            } else {
                return response()->json([
                    'code' => '500',
                    'message' => "Sorry, You have not check in today",
                    'data' => NULL
                ], 200);
            }
        } catch (\Exception $e) {
            return response()->json([
                'code' => '500',
                'message' => $e->getMessage(),
                'data' => NULL
            ], 200);
        }
    }
}