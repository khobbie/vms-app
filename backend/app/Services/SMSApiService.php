<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class SMSApiService
{

    public function call_sms_api($company_name, $destination, $message)
    {

        try {

            $response = Http::get('https://sms.nalosolutions.com/smsbackend/clientapi/Syn_Afriq/send-message/', [
                'username' => env("SMS_USERNAME"),
                'password' => env("SMS_PASSWORD"),
                'type' =>  env("SMS_TYPE"),
                'destination' => $destination,
                'source' =>  env("SMS_SOURCE"),
                'message' => $message,
                'dlr' =>  env("SMS_DLR")
            ]);

            return $response;
        } catch (\Exception $e) {
            throw new \Exception($e->getMessage());
        }
    }
}