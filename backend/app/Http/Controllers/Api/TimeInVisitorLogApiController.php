<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SMSNotificationModel;
use App\Models\TimeInVisitorLogApiModel;
use App\Services\SMSApiService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TimeInVisitorLogApiController extends Controller
{
    public function verifyCustomerId(Request $request)
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


            $sms_message = "Visitor token: $token";

            # Use SMS Service
            $sMSApiService = new SMSApiService();
            $sms = $sMSApiService->call_sms_api($request->company_name, $destination, $sms_message);
            // return $sms;
            if ($sms->ok()) {

                $res = explode("|", $sms->body());

                if ($res[0] != '1701') {
                    return response()->json([
                        'code' => '500',
                        'message' => "Incorrect phone number",
                        'data' => NULL
                    ], 200);
                }

                # INSERT INTO SMS NOTIFICATION TABLE
                $sMSNotificationModel = new SMSNotificationModel();
                $sMSNotificationModel->company_id = $request->company_id;
                $sMSNotificationModel->branch_id = $settings->branchId;
                $sMSNotificationModel->event_id = $settings->eventId;
                $sMSNotificationModel->country_phone_code = $settings->countryCode;
                $sMSNotificationModel->customer_id = $visitor->customerId;
                $sMSNotificationModel->token = $token;
                $sMSNotificationModel->message = $sms_message;
                $sMSNotificationModel->type = "IN";
                $sMSNotificationModel->who = "VISITOR";


                if ($sMSNotificationModel->save()) {

                    $sms_details = SMSNotificationModel::where("id", $sMSNotificationModel->id)->first();
                    // return $sms_details->uuid;

                    return response()->json([
                        'code' => '000',
                        'message' => "Token sent your phone",
                        'data' => [
                            "verification_token" => $token,
                            "verification_token_uuid" => $sms_details->uuid,
                        ]
                    ], 200);
                } else {
                    return response()->json([
                        'code' => '500',
                        'message' => "Something went wrong",
                        'data' => NULL
                    ], 200);
                }
            } else {
                return response()->json([
                    'code' => '500',
                    'message' => "Failed to verify visitor phone number",
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

    public function checkIn(Request $request)
    {
        // return $request;


        $validator = Validator::make($request->all(), [
            'settings.branchId' => 'required',
            'settings.eventId' => 'required',
            'settings.location' => 'required',
            'settings.countryCode' => 'required | numeric',
            'visitor.customerId' => 'required | numeric',
            'visitor.fullName' => 'required',
            'visitor.category_id' => 'required',
            'visitor.typeOfVisit' => 'required',
            'visitor.typeDescription' => 'required',
            'visitor.verification_token_uuid' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'code' => '422',
                'message' => 'Validation Error(s)',
                'data' => $validator->errors()
            ], 422);
        }

        $settings = (object) $request->settings;
        $visitor = (object) $request->visitor;

        $destination = trim($settings->countryCode) . trim($visitor->customerId);

        try {

            $visitor_sms_detail = SMSNotificationModel::where([["uuid", $visitor->verification_token_uuid], ["is_verified", "NO"]])->first();

            if (is_null($visitor_sms_detail)) {
                return response()->json([
                    'code' => '500',
                    'message' => "Expired Token",
                    'data' => NULL
                ], 200);
            } else {
                $timeInVisitorLogApiModel = new TimeInVisitorLogApiModel();
                $timeInVisitorLogApiModel->country_phone_code = $settings->countryCode;
                $timeInVisitorLogApiModel->company_id = $request->company_id;
                $timeInVisitorLogApiModel->event_id = $settings->eventId;
                $timeInVisitorLogApiModel->branch_id = $settings->branchId;
                $timeInVisitorLogApiModel->branch_device_location = $settings->location;

                $timeInVisitorLogApiModel->customer_id = $visitor->customerId;
                $timeInVisitorLogApiModel->fullName = $visitor->fullName;
                $timeInVisitorLogApiModel->purpose_description = $visitor->purpose;
                $timeInVisitorLogApiModel->category_id = $visitor->category_id;
                $timeInVisitorLogApiModel->typeOfVisit = $visitor->typeOfVisit;
                $timeInVisitorLogApiModel->type_description = $visitor->typeDescription;
                $timeInVisitorLogApiModel->time_in = NOW();

                if ($timeInVisitorLogApiModel->save()) {

                    $sMSNotification = SMSNotificationModel::find($visitor_sms_detail->id);

                    $sMSNotification->status = "SENT";
                    $sMSNotification->is_verified = "YES";
                    $sMSNotification->verified_at = NOW();

                    $sMSNotification->save();

                    return response()->json([
                        'code' => '000',
                        'message' => "Welcome " . strtoupper($visitor->fullName),
                        'data' => null
                    ], 200);
                } else {
                    return response()->json([
                        'code' => '500',
                        'message' => "Something went wrong",
                        'data' => null
                    ], 200);
                }
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