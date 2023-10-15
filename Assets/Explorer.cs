using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Explorer : MonoBehaviour
{
    public Material mat;
    public Vector2 pos;
    public float scale = 3.5f;

    private Vector2 smoothPos;
    private float smoothScale;

    private void updateShader() {
        smoothPos = Vector2.Lerp(smoothPos, pos, .08f);
        smoothScale = Mathf.Lerp(smoothScale, scale, .8f);

        float aspect = (float)Screen.width / (float)Screen.height;

        float scaleX = smoothScale;
        float scaleY = smoothScale;

        if(aspect > 1f) {
            scaleY /= aspect;
        } else {
            scaleX *= aspect;
        }
        mat.SetVector("_Area", new Vector4(smoothPos.x, smoothPos.y, scaleX, scaleY));
    }

    private void handleInput() {
        if(Input.GetKey(KeyCode.LeftShift)) {
            scale *= .99f;
        }

        if(Input.GetKey(KeyCode.LeftControl)) {
            scale *= 1.01f;
        }

        if(Input.GetKey(KeyCode.A)) {
            pos.x -= .01f * scale;
        }

        if(Input.GetKey(KeyCode.D)) {
            pos.x += .01f * scale;
        }

        if(Input.GetKey(KeyCode.S)) {
            pos.y -= .01f * scale;
        }

        if(Input.GetKey(KeyCode.W)) {
            pos.y += .01f * scale;
        }
    }

    void Start()
    {
       scale = 3.5f;
    }

    void FixedUpdate()
    {
        handleInput();
        updateShader();
    }
}
