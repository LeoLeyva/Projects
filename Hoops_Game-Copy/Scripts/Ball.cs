using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ball : MonoBehaviour
{
    public ParticleSystem trail;
    public Player p;
    private bool onGround = false;
    // Start is called before the first frame update
    void Start()
    {
        trail.Stop();
    }

    // Update is called once per frame
    void Update()
    {
        /**If the ball is not possessed by the player, and is not on the ground,
         * then particle system [trail] will begin its emission. Else,trail will
         * stop emitting particles-- if it was undergoing emission.*/

        if (!p.hasBall && !onGround)
        {
            trail.Play();
            var te = trail.emission;
            te.enabled = true;
        }
        else
        {
            if (trail.isPlaying)
            {
                trail.Stop();
            }
        }
    }

    /**If the ball collides with the gameObject pertaining to [collision], and
     * the gameObject happens to be the ground, then the ball will be 
     * acknowledged as being on the ground. Else, it will be acknowledged as not 
     * being on the ground.*/


    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.name == "Ground")
        {
            onGround = true;
        }
    }


    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.name == "Ground")
        {
            onGround = false;
        }
    }
}