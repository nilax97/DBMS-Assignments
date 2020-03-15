#include <iostream>
#include <stdlib.h>
#include <vector>
#include <fstream>
#include <algorithm>
#include <cmath>
#include <limits>
#include <algorithm>
#include  <ctime>

using namespace std;

typedef struct points
{
	vector<double> values;
	int size;
	int id;

	void init(int d, int ind)
	{
		size=d;
		id=ind;
		values.resize(d);
	}

}point;


typedef struct knn
{
    double dist;
    point *neighbour;

    knn(double x, point *n)
    {
        dist = x;
        neighbour = n;
    }
}knn;



double distance_point(point &x, point &y)
    {
        double sum=0;
        int d = x.size;
        for(int i=0; i<d; i++)
        {
            double delta = x.values.at(i) - y.values.at(i);
            sum += delta*delta;
        }
        return sqrt(sum);
    }



bool compare_knn (const knn &x, const knn &y)
{
    return (x.dist < y.dist);
}

bool compare_knn2 (const knn &x, const knn &y)
{
  if(x.dist!=y.dist)
  {

    return (x.dist < y.dist);
  }
  else
  {
    for(int i=0; i<x.neighbour->size;++i)
    {
      if(x.neighbour->values[i]!=y.neighbour->values[i])
      {
        return(x.neighbour->values[i] < y.neighbour->values[i]);
      }
    }
    return (1>0);
  }
}


int main(int argc, char* argv[])
{


	char* dataset_file = argv[1];
	//fill all the values in the points after reading from file
	int i,j;
	ifstream in;
	in.open(dataset_file);
	vector<vector<double> > data;
	// vector<vector<point> >all_points;
	int D,N;
	int k=20;
	in >> D >> N;
	data.resize(N);
	// point all_points[N];
	vector<point> all_points(N);
	vector<point> index_to_point(N);


	for(i=0;i<N;i++)
	{
		// cout << "processing point " << i << endl;
		for(j=0;j<D;j++)
		{
			double a;
			in >> a;
			data[i].push_back(a);
			// cout << a << endl;
		}

		// point temp;
		// temp.values = data[i];
		// temp.size = D;
		// temp.id = i;
		all_points[i].values = data[i];
		all_points[i].size = D;
		all_points[i].id = i;
		index_to_point[i] = all_points[i];

	}

	in.close();

  double start = clock();

	char* query_file = argv[2];
  ofstream ofile;
  ofile.open("Seq_results_" + to_string(D) + "_" + to_string(k) + ".txt");
	in.open(query_file);
	int N2;
	in >> D >> N2;
	// cout << "N2 = " << N2 << endl;
	vector<point> q_points(N2);
	for(i=0;i<N2;i++)
	{
		vector<double> data;
		for(j=0;j<D;j++)
		{
			double a;
			in >> a;
			data.push_back(a);
			// cout << a << endl;
		}

		// point temp;
		// temp.values = data[i];
		// temp.size = D;
		// temp.id = i;
		q_points[i].values = data;
		q_points[i].size = D;
		q_points[i].id = i;
		// index_to_point[i] = all_points[i];
	}


	//for 1 point
	double ratio = 0.0;
  for(int l=0;l<N2;l++)
	{
		vector<knn> n_heap;
		make_heap(n_heap.begin(), n_heap.end(), &compare_knn);

		//go through all points
		for(i=0;i<N;i++)
		{
			point* node = &all_points[i];
			double dist = distance_point(*node, q_points[l]);

			if(n_heap.size()<k)
			{
				n_heap.push_back(knn(dist,node));
				make_heap(n_heap.begin(), n_heap.end(), &compare_knn);
			}
			else
			{
				//compare dist of element with top of the heap distance
				knn max_n = n_heap.front();
				double max_dist = max_n.dist;
				if(dist<max_dist)
				{
					n_heap.erase(n_heap.begin());
					make_heap(n_heap.begin(), n_heap.end(), &compare_knn);
		            n_heap.push_back(knn(dist,node));
				}

			}


		}
    sort(n_heap.begin(), n_heap.end(), &compare_knn2);
		//print points
		//cout << "points\n";
    for(int m=0;m<k;m++)
    {
      ofile<<n_heap[m].dist<<" -> ";
      for(j=0;j<D;j++)
      {
        ofile << n_heap[m].neighbour->values[j] << " ";
      }
      ofile << endl;
    }
	}
  double end = clock();
  ofile.close();
  ofstream mfile;
  mfile.open("Time_Seq.txt", ios::app);
  mfile<<D<<" "<<(end-start)/double(CLOCKS_PER_SEC)*1000<<endl;
  mfile.close();
}







