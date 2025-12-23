'use client';

import { useEffect, useState } from 'react';
import { PaymentButton } from '@/components/payment-button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Calendar, DollarSign, User } from 'lucide-react';

interface Project {
  id: string;
  title: string;
  description: string;
  budget: number;
  category: string;
  status: string;
  client_name: string;
  deadline: string;
}

export default function ProjectDetailPage({ params }: { params: { id: string } }) {
  const [project, setProject] = useState<Project | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchProject() {
      try {
        const res = await fetch(`/api/projects/${params.id}`);
        if (!res.ok) throw new Error('Project not found');
        const data = await res.json();
        setProject(data);
      } catch (error) {
        console.error('Failed to fetch project', error);
      } finally {
        setLoading(false);
      }
    }
    fetchProject();
  }, [params.id]);

  if (loading) return <div className="p-10 text-center">Loading...</div>;
  if (!project) return <div className="p-10 text-center">Project not found</div>;

  return (
    <div className="container mx-auto py-10 px-4 max-w-4xl">
      <Card>
        <CardHeader>
          <div className="flex justify-between items-start">
            <div>
              <CardTitle className="text-3xl mb-2">{project.title}</CardTitle>
              <CardDescription className="text-lg">{project.category}</CardDescription>
            </div>
            <Badge variant="secondary" className="text-lg px-4 py-1 capitalize">
              {project.status.replace('_', ' ')}
            </Badge>
          </div>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="grid md:grid-cols-3 gap-4 p-4 bg-slate-50 rounded-lg">
            <div className="flex items-center gap-2">
              <User className="h-5 w-5 text-slate-500" />
              <div>
                <p className="text-sm text-slate-500">Client</p>
                <p className="font-medium">{project.client_name}</p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <DollarSign className="h-5 w-5 text-slate-500" />
              <div>
                <p className="text-sm text-slate-500">Budget</p>
                <p className="font-medium">Rp {project.budget.toLocaleString('id-ID')}</p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <Calendar className="h-5 w-5 text-slate-500" />
              <div>
                <p className="text-sm text-slate-500">Deadline</p>
                <p className="font-medium">{project.deadline}</p>
              </div>
            </div>
          </div>

          <div>
            <h3 className="text-xl font-semibold mb-2">Description</h3>
            <p className="text-slate-700 whitespace-pre-wrap">{project.description}</p>
          </div>

          <div className="border-t pt-6">
            <h3 className="text-xl font-semibold mb-4">Payment</h3>
            <p className="text-slate-600 mb-4">
              Proceed with the payment to start the project. The funds will be held in escrow until the project is completed.
            </p>
            <div className="max-w-xs">
              <PaymentButton
                amount={project.budget}
                projectId={project.id}
                projectTitle={project.title}
              />
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
