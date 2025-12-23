import { NextResponse } from 'next/server';
import { coreApi } from '@/lib/midtrans';

export async function POST(req: Request) {
  try {
    const notificationJson = await req.json();

    // Verify the notification came from Midtrans
    const statusResponse = await coreApi.transaction.notification(notificationJson);

    const orderId = statusResponse.order_id;
    const transactionStatus = statusResponse.transaction_status;
    const fraudStatus = statusResponse.fraud_status;

    console.log(`Transaction notification received. Order ID: ${orderId}. Transaction status: ${transactionStatus}. Fraud status: ${fraudStatus}`);

    // Update database based on transaction status
    if (transactionStatus == 'capture'){
        if (fraudStatus == 'challenge'){
            // TODO: set transaction status on your database to 'challenge'
        } else if (fraudStatus == 'accept'){
            // TODO: set transaction status on your database to 'success'
        }
    } else if (transactionStatus == 'settlement'){
        // TODO: set transaction status on your database to 'success'
    } else if (transactionStatus == 'cancel' || transactionStatus == 'deny' || transactionStatus == 'expire'){
        // TODO: set transaction status on your database to 'failure'
    } else if (transactionStatus == 'pending'){
        // TODO: set transaction status on your database to 'pending'
    }

    return NextResponse.json({ status: 'OK' });
  } catch (error) {
    console.error('Midtrans Notification Error:', error);
    return NextResponse.json(
      { error: 'Failed to process notification' },
      { status: 500 }
    );
  }
}
