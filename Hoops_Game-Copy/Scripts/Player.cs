using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{

    public GameObject ball;
    public GameObject playCam;
    public float bDist = 1f;
    public float tDist = 1f;
    public bool hasBall = true;
    public Rigidbody rb;
    // Start is called before the first frame update
    void Start()
    {
        /**You can't disable rigidbody entirely; simply aspects of it*/
        rb = ball.GetComponent<Rigidbody>();
        rb.useGravity = false;
    }

    // Update is called once per frame
    void Update()
    {
        /**For the sake of convenience, if the ball falls out of bounce, it 
         * is returned back to the player's possession.*/
        if (ball.transform.position.y < -5 && !hasBall)
        {
            hasBall = true;
            rb.useGravity = false;
        }


        /**When the player is holding the ball, the ball is not rotating. 
         * If the player left clicks their mouse, then the ball is
        * launched.*/

        if (hasBall)
        {
            ball.transform.position = playCam.transform.position
                + playCam.transform.forward * bDist;
            rb.velocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
            if (Input.GetMouseButtonDown(0))
            {
                hasBall = false;
                rb.useGravity = true;
                rb.AddForce(playCam.transform.forward * tDist);
            }
        }

    }


    /**For the sake of convenience, if the player approaches the ball, 
     * then the player can equip it.*/

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.name == "Ball")
        {
            hasBall = true;
            rb.useGravity = false;
        }
    }
}
