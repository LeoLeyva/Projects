using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Score : MonoBehaviour
{

    public AudioSource swish;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }


    private void OnTriggerEnter(Collider other)
    {

        /**If the ball goes through the hoope, the audio of the swishing of a 
         * net is played.*/
        if (other.name == "Ball")
        {
            swish.Play();
        }
    }
}
