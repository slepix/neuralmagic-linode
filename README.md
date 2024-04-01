
# Neural Magic on Linode

A quick demo of Neural Magic's DeepSparse runtime on Linode VM's used for sentiment analysis. 
This code will deploy 2 x Dedicated 4 GB Linode VM's, Nodebalancer and configure servers with DeepSparse. 

## Deployment

To deploy this project run

```bash
  git clone https://github.com/slepix/neuralmagic-linode
  cd neuralmagic-linode
  terrafom init
  terraform plan
  terraform apply
```
Check out this blog post - https://blog.slepcevic.net/sentiment-analysis-of-40-thousand-movie-reviews-in-less-than-an-hour-using-neural-magics-deepsparse-inference-runtime-and-linode/ for more details on how to test it out. 
