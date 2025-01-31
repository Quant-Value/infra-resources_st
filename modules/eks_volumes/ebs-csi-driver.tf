data "aws_iam_policy_document" "ebs_csi_driver"{ #  NO FUNCIONA TODO EL CODIGO DE ESTE ARCHIVO, SI FUNCIONA PERO DA FALLOS AL APROVISIONAR VOLUMENES.
    statement{
        effect = "Allow"
        principals{
            type= "Service"
            identifiers= ["pods.eks.amazonaws.com"]
        }
        actions= [
            "sts:AssumeRole",
            "sts:TagSession"
        ]
    }
}

resource "aws_iam_role" "ebs_csi_driver"{
    name="mi-cluster-stb-ebs-csi-driver"
    assume_role_policy=data.aws_iam_policy_document.ebs_csi_driver.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver"{
    policy_arn= "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    role = aws_iam_role.ebs_csi_driver.name
}

resource "aws_eks_pod_identity_association" "ebs_csi_driver"{
    cluster_name = "mi-cluster-stb"
    namespace = "kube-system"
    service_account= "ebs-csi-controller-sa"
    role_arn= aws_iam_role.ebs_csi_driver.arn
}

resource "aws_eks_addon" "ebs_csi_driver"{
    cluster_name="mi-cluster-stb"
    addon_name="aws-ebs-csi-driver"
    addon_version= "v1.38.1-eksbuild.2"
    service_account_role_arn=aws_iam_role.ebs_csi_driver.arn
}
