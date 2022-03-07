<?php

namespace App\Http\Controllers;

use App\Services\SMSApiService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class VerifyTimeInCustomerIdController extends Controller
{
    public function verifyCustomerId(Request $request)
    {
        // return $request;


        $validator = Validator::make($request->all(), [
            'settings.branchId' => 'required',
            'settings.eventId' => 'required',
            'settings.location' => 'required',
            'settings.countryCode' => 'required',
            'visitor.customerId' => 'required',
            // 'visitor.fullName' => 'required',
            // 'visitor.category' => 'required',
            // 'visitor.typeOfVisit' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'code' => '422',
                'message' => 'Validation Error(s)',
                'data' => $validator->errors()
            ], 422);
        }

        try {
             $sMSApiService = new SMSApiService();
                $sms = $sMSApiService->call_sms_api(1, , "Message");
        } catch (\Throwable $th) {
            //throw $th;
        }


        $timeInVisitorLogApiModel = new TimeInVisitorLogApiModel();
        $timeInVisitorLogApiModel->country_phone_code = $request->settings->countryCode;
        $timeInVisitorLogApiModel->event_id = $request->settings->eventId;
        $timeInVisitorLogApiModel->branch_id = $request->settings->branchId;
        $timeInVisitorLogApiModel->branch_device_location = $request->settings->location;

        $timeInVisitorLogApiModel->customer_id = $request->visitor->customerId;
        $timeInVisitorLogApiModel->fullName = $request->visitor->fullName;
        $timeInVisitorLogApiModel->category_id = $request->visitor->customerId;
        $timeInVisitorLogApiModel->typeOfVisit = $request->visitor->typeOfVisit;
    }
}
