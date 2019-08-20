using System;
using UnityEngine;
using System.Collections;

public class PostEffect : MonoBehaviour {

	public Material mat;

	private void Start()
	{
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.MotionVectors;
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		Graphics.Blit (src, dest, mat);
	}
}