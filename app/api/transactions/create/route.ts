import { NextResponse } from 'next/server';
import { snap } from '@/lib/midtrans';
import { v4 as uuidv4 } from 'uuid';

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { amount, projectId, projectTitle, customerDetails } = body;

    // In a real app, you would validate the project and user here
    // and potentially create a pending transaction in your database.

    const orderId = `ORDER-${uuidv4()}`;

    const parameter = {
      transaction_details: {
        order_id: orderId,
        gross_amount: amount,
      },
      item_details: [
        {
          id: projectId,
          price: amount,
          quantity: 1,
          name: projectTitle.substring(0, 50), // Midtrans name limit
        },
      ],
      customer_details: customerDetails,
    };

    const transaction = await snap.createTransaction(parameter);

    // TODO: Save transaction.token and orderId to your database here

    return NextResponse.json({
      token: transaction.token,
      redirect_url: transaction.redirect_url,
      orderId: orderId
    });
  } catch (error) {
    console.error('Midtrans Error:', error);
    return NextResponse.json(
      { error: 'Failed to create transaction' },
      { status: 500 }
    );
  }
}
