<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class SMSApiService
{

    public function call_sms_api($company_name, $destination, $message)
    {

        try {

            $response = Http::get('https://sms.nalosolutions.com/smsbackend/clientapi/Syn_Afriq/send-message/', [
                'username' => 'BlueFS_sms',
                'password' => 'pass1234',
                'type' => '1',
                'destination' => $destination,
                'source' => 'BlueFS',
                'message' => $message,
                'dlr' => '1'
            ]);

            return $response;
        } catch (\Exception $e) {
            throw new \Exception($e->getMessage());
        }
    }
}
