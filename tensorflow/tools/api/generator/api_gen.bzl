"""Targets for generating TensorFlow Python API __init__.py files."""

# keep sorted
TENSORFLOW_API_INIT_FILES = [
    # BEGIN GENERATED FILES
    "__init__.py",
    "app/__init__.py",
    "bitwise/__init__.py",
    "compat/__init__.py",
    "data/__init__.py",
    "debugging/__init__.py",
    "distributions/__init__.py",
    "distributions/bijectors/__init__.py",
    "dtypes/__init__.py",
    "errors/__init__.py",
    "feature_column/__init__.py",
    "gfile/__init__.py",
    "graph_util/__init__.py",
    "image/__init__.py",
    "io/__init__.py",
    "initializers/__init__.py",
    "keras/__init__.py",
    "keras/activations/__init__.py",
    "keras/applications/__init__.py",
    "keras/applications/densenet/__init__.py",
    "keras/applications/inception_resnet_v2/__init__.py",
    "keras/applications/inception_v3/__init__.py",
    "keras/applications/mobilenet/__init__.py",
    "keras/applications/nasnet/__init__.py",
    "keras/applications/resnet50/__init__.py",
    "keras/applications/vgg16/__init__.py",
    "keras/applications/vgg19/__init__.py",
    "keras/applications/xception/__init__.py",
    "keras/backend/__init__.py",
    "keras/callbacks/__init__.py",
    "keras/constraints/__init__.py",
    "keras/datasets/__init__.py",
    "keras/datasets/boston_housing/__init__.py",
    "keras/datasets/cifar10/__init__.py",
    "keras/datasets/cifar100/__init__.py",
    "keras/datasets/fashion_mnist/__init__.py",
    "keras/datasets/imdb/__init__.py",
    "keras/datasets/mnist/__init__.py",
    "keras/datasets/reuters/__init__.py",
    "keras/estimator/__init__.py",
    "keras/initializers/__init__.py",
    "keras/layers/__init__.py",
    "keras/losses/__init__.py",
    "keras/metrics/__init__.py",
    "keras/models/__init__.py",
    "keras/optimizers/__init__.py",
    "keras/preprocessing/__init__.py",
    "keras/preprocessing/image/__init__.py",
    "keras/preprocessing/sequence/__init__.py",
    "keras/preprocessing/text/__init__.py",
    "keras/regularizers/__init__.py",
    "keras/utils/__init__.py",
    "keras/wrappers/__init__.py",
    "keras/wrappers/scikit_learn/__init__.py",
    "layers/__init__.py",
    "linalg/__init__.py",
    "logging/__init__.py",
    "losses/__init__.py",
    "manip/__init__.py",
    "math/__init__.py",
    "metrics/__init__.py",
    "nn/__init__.py",
    "nn/rnn_cell/__init__.py",
    "profiler/__init__.py",
    "python_io/__init__.py",
    "quantization/__init__.py",
    "resource_loader/__init__.py",
    "strings/__init__.py",
    "saved_model/__init__.py",
    "saved_model/builder/__init__.py",
    "saved_model/constants/__init__.py",
    "saved_model/loader/__init__.py",
    "saved_model/main_op/__init__.py",
    "saved_model/signature_constants/__init__.py",
    "saved_model/signature_def_utils/__init__.py",
    "saved_model/tag_constants/__init__.py",
    "saved_model/utils/__init__.py",
    "sets/__init__.py",
    "sparse/__init__.py",
    "spectral/__init__.py",
    "summary/__init__.py",
    "sysconfig/__init__.py",
    "test/__init__.py",
    "train/__init__.py",
    "train/queue_runner/__init__.py",
    "user_ops/__init__.py",
    # END GENERATED FILES
]

# keep sorted
ESTIMATOR_API_INIT_FILES = [
    # BEGIN GENERATED ESTIMATOR FILES
    "__init__.py",
    "estimator/__init__.py",
    "estimator/export/__init__.py",
    "estimator/inputs/__init__.py",
    # END GENERATED ESTIMATOR FILES
]

# Creates a genrule that generates a directory structure with __init__.py
# files that import all exported modules (i.e. modules with tf_export
# decorators).
#
# Args:
#   name: name of genrule to create.
#   output_files: List of __init__.py files that should be generated.
#     This list should include file name for every module exported using
#     tf_export. For e.g. if an op is decorated with
#     @tf_export('module1.module2', 'module3'). Then, output_files should
#     include module1/module2/__init__.py and module3/__init__.py.
#   root_init_template: Python init file that should be used as template for
#     root __init__.py file. "# API IMPORTS PLACEHOLDER" comment inside this
#     template will be replaced with root imports collected by this genrule.
#   srcs: genrule sources. If passing root_init_template, the template file
#     must be included in sources.
#   api_name: Name of the project that you want to generate API files for
#     (e.g. "tensorflow" or "estimator").
#   package: Python package containing the @tf_export decorators you want to
#     process
#   package_dep: Python library target containing your package.

def gen_api_init_files(
        name,
        output_files = TENSORFLOW_API_INIT_FILES,
        root_init_template = None,
        srcs = [],
        api_name = "tensorflow",
        package = "tensorflow.python",
        package_dep = "//tensorflow/python:no_contrib",
        output_package = "tensorflow"):
    root_init_template_flag = ""
    if root_init_template:
      root_init_template_flag = "--root_init_template=$(location " + root_init_template + ")"

    api_gen_binary_target = "create_" + package + "_api"
    native.py_binary(
        name = "create_" + package + "_api",
        srcs = ["//tensorflow/tools/api/generator:create_python_api.py"],
        main = "//tensorflow/tools/api/generator:create_python_api.py",
        srcs_version = "PY2AND3",
        visibility = ["//visibility:public"],
        deps = [
            package_dep,
            "//tensorflow/tools/api/generator:doc_srcs",
        ],
    )

    native.genrule(
        name = name,
        outs = output_files,
        cmd = (
            "$(location :" + api_gen_binary_target + ") " +
            root_init_template_flag + " --apidir=$(@D) --apiname=" +
            api_name + " --package=" + package + " --output_package=" +
            output_package + " $(OUTS)"),
        srcs = srcs,
        tools = [":" + api_gen_binary_target ],
        visibility = ["//tensorflow:__pkg__"],
    )
