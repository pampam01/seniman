import { NextResponse } from 'next/server';

// Mock data since we don't have database connection details
const MOCK_PROJECTS = [
  {
    id: '1',
    title: 'Batik Design for Corporate Uniform',
    description: 'Looking for a skilled Batik artist to design a modern pattern for our company uniforms.',
    budget: 5000000,
    category: 'Batik Design',
    status: 'posted',
    client_name: 'PT Maju Mundur',
    deadline: '2023-12-31'
  },
  {
    id: '2',
    title: 'Digital Illustration for Book Cover',
    description: 'Need a fantasy style illustration for a young adult novel cover.',
    budget: 2500000,
    category: 'Digital Art',
    status: 'posted',
    client_name: 'Pustaka Indonesia',
    deadline: '2023-11-15'
  },
  {
    id: '3',
    title: 'Traditional Wayang Carving',
    description: 'Custom wayang kulit character creation.',
    budget: 1500000,
    category: 'Craft',
    status: 'posted',
    client_name: 'Budaya Kita',
    deadline: '2023-10-20'
  }
];

export async function GET() {
  return NextResponse.json(MOCK_PROJECTS);
}
