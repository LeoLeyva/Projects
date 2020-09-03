using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyControl : MonoBehaviour
{

    public ParticleSystem explosion;


    private void OnTriggerEnter2D(Collider2D collision)
    {
        /**If there is a collision between an enemy and the player's missile,
         * then the enemy object and missile will disappear and be replaced by 
         * the custom-made explosion. The explosion will then disappear after
         * a few seconds.*/

        if (collision.CompareTag("PlayerMissile"))
        {
            ParticleSystem myExplosion = Instantiate(explosion);
            /** Note: 
             * transform.parent.parent, in this case, refers to the enemy 
             * container; setting the container as the explosion's parent 
             * ensures that the explosion does not move along with the 
             * container.*/
            myExplosion.transform.SetParent(transform.parent.parent);
            myExplosion.transform.position = transform.position;
            Destroy(collision.gameObject);
            Destroy(this.gameObject);
            Destroy(myExplosion, 2);
        }
    }

 
}
