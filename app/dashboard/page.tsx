'use client';

import { useEffect, useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

interface Project {
  id: string;
  title: string;
  description: string;
  budget: number;
  category: string;
  status: string;
}

export default function DashboardPage() {
  const [projects, setProjects] = useState<Project[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchProjects() {
      try {
        const res = await fetch('/api/projects');
        const data = await res.json();
        setProjects(data);
      } catch (error) {
        console.error('Failed to fetch projects', error);
      } finally {
        setLoading(false);
      }
    }
    fetchProjects();
  }, []);

  return (
    <div className="container mx-auto py-10 px-4">
      <h1 className="text-3xl font-bold mb-8">Dashboard</h1>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {loading ? (
          <p>Loading projects...</p>
        ) : projects.length > 0 ? (
          projects.map((project) => (
            <Card key={project.id} className="flex flex-col">
              <CardHeader>
                <CardTitle className="text-xl">{project.title}</CardTitle>
                <CardDescription>{project.category}</CardDescription>
              </CardHeader>
              <CardContent className="flex-1">
                <p className="text-sm text-gray-500 mb-4 line-clamp-3">
                  {project.description}
                </p>
                <div className="mt-auto flex items-center justify-between">
                  <span className="font-semibold">
                    Rp {project.budget.toLocaleString('id-ID')}
                  </span>
                  <Link href={`/projects/${project.id}`}>
                    <Button variant="outline">View Details</Button>
                  </Link>
                </div>
              </CardContent>
            </Card>
          ))
        ) : (
          <p>No projects found.</p>
        )}
      </div>
    </div>
  );
}
