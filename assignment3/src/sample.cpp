#include <iostream>
#include <stdlib.h>
#include <vector>
#include <fstream>
#include <algorithm>
#include <cmath>
#include <limits>
#include <queue>

using namespace std;

int total_nodes=0;

typedef struct tree_node
{
	int split_dim;
	int sizes;
	vector< vector<int> > sorted_arr;
	struct tree_node* left;
	struct tree_node* right;

}t_node;


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

typedef struct MBR
{
    double dist;
    t_node *node;

    MBR(double d, t_node *p)
    {
        dist = d;
        node = p;
    }
}MBR;

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

bool compare_MBR (const MBR &x, const MBR &y)
{
    return (x.dist > y.dist);
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



class kdtree
{
	public:
	t_node* root;
	int d;
	int n;
	vector<vector<int> >  main_sorted;
	vector<point> index_to_point;

	kdtree(int dim, int points, vector< vector<int> > sorted, vector<point> ind_to_po)
	{
		root=(t_node*)malloc( 5000000 *sizeof(t_node));
		d=dim;
		n=points;
		root->split_dim=0;
		root->sizes=n;
		root->sorted_arr.resize(d,vector<int>(n));
		root->sorted_arr = sorted;
		root->left=NULL;
		root->right=NULL;
		main_sorted=sorted;
		index_to_point=ind_to_po;
	}

	void make_tree(t_node* parent)
	{
		if(parent->sizes>1)
		{
			t_node* lef=(t_node*)malloc(5000000*sizeof(t_node));
			t_node* rig=(t_node*)malloc(5000000*sizeof(t_node));

			point median=index_to_point[parent->sorted_arr[parent->split_dim][(parent->sizes-1)/2]];
			lef->split_dim=(parent->split_dim+1)%d;
			rig->split_dim=(parent->split_dim+1)%d;

			// making the sorted array in each node separately
			vector<vector<int> > lef_arr;
			vector<vector<int> > rig_arr;

			int l_count=0;
			int r_count=0;

			for(int i=0;i<d;i++)
			{

				vector<int> l_temp;
				vector<int> r_temp;
				l_count=0;
				r_count=0;

				for(int j=0;j<parent->sizes;j++)
				{
					if(&index_to_point[parent->sorted_arr[i][j]]==&index_to_point[parent->sorted_arr[parent->split_dim][(parent->sizes-1)/2]])
						continue;

					if(index_to_point[parent->sorted_arr[i][j]].values[parent->split_dim]<=median.values[parent->split_dim])
					{
						l_temp.push_back(parent->sorted_arr[i][j]);
						l_count++;
					}
					else if(index_to_point[parent->sorted_arr[i][j]].values[parent->split_dim]>median.values[parent->split_dim])
					{
						r_temp.push_back(parent->sorted_arr[i][j]);
						r_count++;
					}
				}

				lef_arr.push_back(l_temp);
				lef->sorted_arr.push_back(l_temp);
				rig_arr.push_back(r_temp);
				rig->sorted_arr.push_back(r_temp);

			}

			lef->sizes=l_count;
			rig->sizes=r_count;

			lef->left=NULL;
			rig->right=NULL;
			lef->right=NULL;
			rig->left=NULL;
			if(l_count==0)
				parent->left=NULL;
			else
				parent->left=lef;

			if(r_count==0)
				parent->right=NULL;
			else
				parent->right=rig;


			if(parent->left != NULL)
			{
				total_nodes+=1;
				make_tree(parent->left);
			}
			if(parent->right != NULL)
			{
				total_nodes+=1;
				make_tree(parent->right);
			}
		}

	}

	double distance_point(point &x, point &y)
    {
        double sum=0;
        for(int i=0; i<d; i++)
        {
            double delta = x.values.at(i) - y.values.at(i);
            sum += delta*delta;
        }
        return sqrt(sum);
    }

    double distance_MBR(point &x, t_node *y)
    {
        double sum = 0;
        for(int i=0; i<d; i++)
        {

            double delta = 0.0;
            double r_min = index_to_point[y->sorted_arr[i][0]].values[i];
            double r_max = index_to_point[y->sorted_arr[i][(y->sizes-1)]].values[i];
            double p = x.values[i];
            if(r_min > p)
            {
                delta = r_min - p;
            }
            else if(r_max < p)
            {
                delta = p - r_max;
            }
            sum+=(delta*delta);
        }
        return sqrt(sum);
    }

    vector<knn> knn_search(point x, int k)
    {
        queue<MBR> can_heap;
        MBR root_node(distance_MBR(x, root), root);
        can_heap.push(root_node);
        vector<knn> n_heap;
        int counter=0;
        while(can_heap.size()>0)
        {
            t_node *popped_node = can_heap.front().node;
            can_heap.pop();

            point *node = &index_to_point[popped_node->sorted_arr[popped_node->split_dim].at((popped_node->sizes-1)/2)];
            double dist = distance_point(*node, x);

            if(n_heap.size()<k)
            {
              	n_heap.push_back(knn(dist,node));
            	make_heap(n_heap.begin(), n_heap.end(), &compare_knn);

	        	if(popped_node->left!=NULL)
	            {
	            	double dis_left = distance_MBR(x,popped_node->left);
	            	can_heap.push(MBR(dis_left, popped_node->left));
	            }
	            if(popped_node->right!=NULL)
	            {
	            	double dis_right = distance_MBR(x,popped_node->right);
		            can_heap.push(MBR(dis_right, popped_node->right));
	            }
            }

            else
            {
            	knn max_n = n_heap.front();
            	double max_dist = max_n.dist;

	            if(dist< max_n.dist)
	            {
	            	n_heap.erase(n_heap.begin());
	            	make_heap(n_heap.begin(), n_heap.end(), &compare_knn);
	                n_heap.push_back(knn(dist,node));
	                make_heap(n_heap.begin(), n_heap.end(), &compare_knn);
	                max_dist = n_heap.front().dist;
	            }
	            if(popped_node->left!=NULL)
	            {
	            	double dis_left = distance_MBR(x,popped_node->left);
	            	if(dis_left<max_dist)
	            	{
	                	can_heap.push(MBR(dis_left, popped_node->left));	            	}
	            }

	            if(popped_node->right!=NULL)
	            {
	            	double dis_right = distance_MBR(x,popped_node->right);
	         		if(dis_right<max_dist)
		            {
		                can_heap.push(MBR(dis_right, popped_node->right));
		            }
	            }
        	}
        }
        return n_heap;

    }


};



int dim;


bool custom_comparison(const point &x, const point &y)
{

	if (x.values[dim]!=y.values[dim])
	{
		return(x.values[dim] < y.values[dim]);
	}
	else
		return(x.values[dim] < y.values[dim]);
}

int main(int argc, char* argv[]) {

	char* dataset_file = argv[1];

	int i,j;
	ifstream in;
	in.open(dataset_file);
	vector<vector<double> > data;
	int D,N;
	in >> D >> N;
	data.resize(N);
	vector<point> all_points(N);
	vector<point> index_to_point(N);


	for(i=0;i<N;i++)
	{
		for(j=0;j<D;j++)
		{
			double a;
			in >> a;
			data[i].push_back(a);
		}
		all_points[i].values = data[i];
		all_points[i].size = D;
		all_points[i].id = i;
		index_to_point[i] = all_points[i];

	}

	in.close();

	vector<vector<int> > sorted;
	sorted.resize(D,vector<int>(N));

	for(dim=0;dim<D;dim++)
	{

		sort(all_points.begin(),all_points.end() ,&custom_comparison );
		vector<int> points_by_id(N);
		for(i=0;i<N;i++)
		{
			points_by_id[i] = (all_points[i].id);
		}
		sorted[dim] = (points_by_id);
	}

	kdtree* mytree = (kdtree*) malloc(N * sizeof(kdtree));
	mytree = new kdtree(D, N,sorted, index_to_point);
	mytree->make_tree(mytree->root);

	// [TODO] Construct kdTree using dataset_file here

	// Request name/path of query_file from parent by just sending "0" on stdout
	cout << 0 << endl;

	// Wait till the parent responds with name/path of query_file and k | Timer will start now
	char* query_file = new char[100];
	int k;
	cin >> query_file >> k;


	// cerr << dataset_file << " " << query_file << " " << k << endl;

in.open(query_file);
	int N2;
	in >> D >> N2;
	vector<point> q_points(N2);
	for(i=0;i<N2;i++)
	{
		vector<double> data;
		for(j=0;j<D;j++)
		{
			double a;
			in >> a;
			data.push_back(a);
		}
		q_points[i].values = data;
		q_points[i].size = D;
		q_points[i].id = i;
	}
	// [TODO] Read the query point from query_file, do kNN using the kdTree and output the answer to results.txt

ofstream ofile;
	ofile.open("results.txt");

	for(i=0;i<N2;i++)
	{
		vector<knn> knn_sear=mytree->knn_search(q_points[i],k);
    sort(knn_sear.begin(), knn_sear.end(), &compare_knn2);
		for(int m=0;m<k;m++)
		{
			for(j=0;j<D;j++)
			{
	    		ofile<<knn_sear[m].neighbour->values[j]<<" ";
			}
	      	ofile<<endl;
		}
	}
  ofile.close();
	// Convey to parent that results.txt is ready by sending "1" on stdout | Timer will stop now and this process will be killed
	cout << 1 << endl;
}
